import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class ListDetailProvider extends ChangeNotifier{
  List<MovieListContent> _items = [];
  List<MovieListContent> get items => _items;
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


  Future<void> fetchData(String listId) async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}mls/content/?list_id=${listId}&page=$_page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
            List<MovieListContent>.from(data['results'].map((postJson) => MovieListContent.fromJson(postJson)))        
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

    void removeRequest(BuildContext context, String listId, String movieId) async{
    final String base_url = '${Globals().url}mls/d/?action=remove&movie=${movieId}&id=$listId';
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse(base_url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        'Content-Type':'application/json; charset=utf-8',
        }
      );
    if(response.statusCode!=204){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      items.removeWhere((element) => element.id == movieId);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Removed from list', Icon(Icons.check), true));
      // Navigator.pop(context);
    }
    notifyListeners();
  }
}