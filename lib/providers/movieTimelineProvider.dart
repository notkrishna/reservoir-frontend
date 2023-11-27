import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class MovieTimelineProvider extends ChangeNotifier{
  int _page = 1;
  int get page => _page;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMorePosts = true;
  List<Timeline> _posts = [];
  List<Timeline> get posts => _posts;

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
      Uri.parse('${Globals().url}api/ts/list/m/$movieId'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        posts.addAll(List<Timeline>.from(data['results'].map((postJson) => Timeline.fromJson(postJson))));
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

  Future<void> postData(BuildContext context, String stamp, String stampText, String movieId, bool isStampStatusPublic) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(
      Uri.parse('${Globals().url}api/ts/list/'),
    body: json.encode({'stamp':int.parse(stamp), 'stampText':stampText, 'movie':movieId, 'isPublic':isStampStatusPublic}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode==201){
      final newTs = Timeline.fromJson(jsonDecode(response.body));
      _posts.insert(0,newTs);
      print(posts[0].usertag);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Post created successfully', Icon(Icons.edit), true));
      Navigator.pop(context);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error', Icon(Icons.close), true));
      throw Exception(response.body);
    }
  }

  Future<void> DeleteData(BuildContext context,String movie, int stamp) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      posts.removeWhere((c) => c.movie == movie && c.stamp == stamp);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Deleted successfully', Icon(Icons.delete), true));
    } else {
      // Request failed
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }

  Future<void> editData(context, String stamp, String stampText, String id, String movieId, bool isStampStatusPublic) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(
    Uri.parse('${Globals().url}api/ts/$movieId&$stamp'),
    body: json.encode({'stamp':int.parse(stamp), 'stampText':stampText, 'movie':movieId, 'isPublic':isStampStatusPublic}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Something went wrong', Icon(Icons.close), true));
      throw Exception(response.body);
    } else {
      final ts = Timeline.fromJson(jsonDecode(response.body));
      final index = posts.indexWhere((element) => element.id == id);
      if(index!=-1){
        posts[index] = ts;
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