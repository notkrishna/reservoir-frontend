import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class MovieListProvider extends ChangeNotifier{
  List<MovieList> _items = [];
  List<MovieList> get items => _items;
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


  Future<void> fetchData(String userId) async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}mls/?user=$userId&page=$page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
          List<MovieList>.from(data['results'].map((postJson) => MovieList.fromJson(postJson)))          
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

  Future<void> postData(BuildContext context, String lname) async { 
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}mls/d/?action=create'),
    body: json.encode({'list_name':lname}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=201){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      final moviels = MovieList.fromJson(jsonDecode(response.body));
      items.add(moviels);
      notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' List created', Icon(Icons.list), true));
        Navigator.pop(context);
    }
  }

Future<void> editData(BuildContext context, String lname, String lsId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(Uri.parse('${Globals().url}mls/d/?id=$lsId'),
    body: json.encode({'list_name':lname}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      final mList = MovieList.fromJson(jsonDecode(response.body));
      int index = _items.indexWhere((element) => element.id == lsId);
      if(index != -1) {
        items[index] = mList;
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' List edited', Icon(Icons.list), true));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Something went wrong', Icon(Icons.close), false));
      }

      }
    notifyListeners(); 

  }
  
  Future<void> deleteRequest(BuildContext context, String list_id) async{
    final String base_url = '${Globals().url}mls/d/?action=delete&id=$list_id';
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse(base_url),
      headers: {
          'Content-Type':'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    if(response.statusCode!=204){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      items.removeWhere((c) => c.id == list_id);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' List deleted successfully', Icon(Icons.check), true));
      Navigator.pop(context);
      // Navigator.pop(context);
    }
  }
}