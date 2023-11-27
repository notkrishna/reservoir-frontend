import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

import '../models/ratingModel.dart';

class MovieReviewProvider extends ChangeNotifier{
  int _page = 1;
  int get page => _page;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMorePosts = true;
  bool _isReviewed = false;
  bool get isReviewed => _isReviewed;
  List<Rating> _posts = [];
  List<Rating> get posts => _posts;

  

  // String _nextPageUrl = '';
  // String get nextPageUrl => _nextPageUrl;

  // void remove(int postId) {
  //   posts.removeWhere((c) => c.id == postId);
  //   notifyListeners();
  // }

  // void createPost(){
  //   posts.add(value);
  // }

  Future<void> fetchPosts(String movieId) async {
    if (!_isLoading && _hasMorePosts) {
      _isLoading = true;


    try {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}api/rating/list/$movieId'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        posts.addAll(List<Rating>.from(data['results'].map((postJson) => Rating.fromJson(postJson))));
        _isReviewed = data['is_reviewed'];
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
        notifyListeners();

      }
    }
  }

  Future<void> postData(BuildContext context, int rating, String review, String movieId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(
      Uri.parse('${Globals().url}api/rating/create/${movieId}/'),
    body: json.encode({'rating':rating,'review':review}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode==201){
      final newTs = Rating.fromJson(jsonDecode(response.body));
      _isReviewed = true;
      _posts.insert(0,newTs);
      print(posts[0].usertag);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Review Posted', Icon(Icons.check), true));
      Navigator.pop(context);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error', Icon(Icons.close), false));
      throw Exception(response.body);
    }
  }

  Future<void> editData(context, int rating, String review, String movieId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    String currUser = await FirebaseAuth.instance.currentUser!.uid;
    final response = await http.put(
      Uri.parse('${Globals().url}api/rating/${movieId}/'),
    body: json.encode({"rating":rating, "review":review}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Something went wrong', Icon(Icons.close), true));
      throw Exception(response.body);
    } else {
      final review = Rating.fromJson(jsonDecode(response.body));
      final index = posts.indexWhere((element) => element.user == currUser);
      print(currUser);
      if(index!=-1){
        posts[index] = review;
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Post edited', Icon(Icons.check), true));
        Navigator.pop(context);
        // notifyListeners();

      } else {
        print('-1');
      }
        notifyListeners();
    }
  }

  Future<void> DeleteData(String movieId, String postId, BuildContext context) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse('${Globals().url}api/rating/${movieId}/'),
      
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      _isReviewed = false;
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
  // void
}