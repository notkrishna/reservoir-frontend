import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class ProgressProvider extends ChangeNotifier{
  List<ProgressMovies> _items = [];
  List<ProgressMovies> get items => _items;
  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;
  int _page = 1;
  int get page => _page;

  // Future<void> addComment(String type, int postId, String commentText) async {
  //   postData(type, postId, commentText);
  //   notifyListeners();
  // }

  // void remove(int postId) {
  //   posts.removeWhere((c) => c.id == postId);
  //   notifyListeners();
  // }

  Future<void> doneWatching(BuildContext context, String movieId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(
      Uri.parse('${Globals().url}progress/$movieId/'),
      body: jsonEncode({'movie':movieId, 'isDone':true}),
      headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode==200){
      _items.removeWhere((element) => element.movie == movieId);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Done watching', Icon(Icons.check), true));
    }
    notifyListeners();
  }

  Future<void> fetchData(String userId) async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}progress/?user=$userId&page=$_page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
            List<ProgressMovies>.from(data['results'].map((postJson) => ProgressMovies.fromJson(postJson)))
          );
        _page++;
        // _isLoading = false;
        try {
          _nextPageUrl = data['next'] as String? ?? 'null';
        } catch(e) {
          _nextPageUrl = 'null';
        }
        notifyListeners();
      } else {
        throw Exception(response.body);
      }
    }
}