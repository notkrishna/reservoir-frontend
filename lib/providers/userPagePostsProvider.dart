import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class UserPageProvider extends ChangeNotifier{
  int _page = 1;
  int get page => _page;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMorePosts = true;
  List<Tribe> _posts = [];
  List<Tribe> get posts => _posts;

  // String _nextPageUrl = '';
  // String get nextPageUrl => _nextPageUrl;

  // void remove(int postId) {
  //   posts.removeWhere((c) => c.id == postId);
  //   notifyListeners();
  // }

  // void createPost(){
  //   posts.add(value);
  // }

  Future<void> fetchPosts(String userId) async {
    if (!_isLoading && _hasMorePosts) {
      _isLoading = true;


    try {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
          Uri.parse('${Globals().url}api/post/list/user/?page=$_page&u=${userId}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        posts.addAll(List<Tribe>.from(data['results'].map((postJson) => Tribe.fromJson(postJson))));
        _page++;
        print(posts.length);
        try {
          _hasMorePosts = data['next'] != null;
        } catch(e) {
          _hasMorePosts = false;
        }
      } else {
        throw Exception(response.body);
      }
      
    } catch (e) {
      print('Error: $e');
    } finally {
        _isLoading = false;

      }


    }
        notifyListeners();
  }

  
  Future<void> DeleteData(String postId, BuildContext context) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/post/$postId/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      posts.removeWhere((c) => c.id == postId);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg('Post deleted successfully', Icon(Icons.delete), true));  
      notifyListeners();
      // widget.onDelete();
    } else {
      // Request failed
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg('Failed to delete post', Icon(Icons.close), false));  
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }

  Future<void> editData(context, String title, String caption, String id, String movie) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(Uri.parse('${Globals().url}api/post/$id/'),
    body: json.encode({'title':title, 'caption':caption, 'movie':movie}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Something went wrong', Icon(Icons.close), true));
      throw Exception(response.body);
    } else {
      final post = Tribe.fromJson(jsonDecode(response.body));
      final index = posts.indexWhere((element) => element.id == id);
      if(index!=-1){
        posts[index] = post;
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Post edited', Icon(Icons.check), true));
        Navigator.pop(context);
        // notifyListeners();

      } else {
        print('-1');
      }
        notifyListeners();
    }
  }
  // void
}