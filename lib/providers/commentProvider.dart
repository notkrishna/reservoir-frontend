import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/main.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class CommentProvider extends ChangeNotifier{
  List<PostComment> _comments = [];
  List<PostComment> get comments => _comments;
  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;
  int _page = 1;
  int get page => _page;

  // Future<void> addComment(String type, int postId, String commentText) async {
  //   postData(type, postId, commentText);
  //   notifyListeners();
  // }

  void remove(int commentId) {
    comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }


  Future<void> fetchComments(String type, String post) async {
    if (_nextPageUrl == 'null') {
      return;
    }
    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/$type/comment/list/?post=$post&page=$_page'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
          comments.addAll(List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson))));
          _page++;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> refreshComments(String type, String post) async {

    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/$type/comment/list/?post=$post&page=1'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<PostComment> refreshList = List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson)));
        _comments = refreshList;
        _page = 2;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }


  Future<void> postData(String type, String postId, String commentText) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}api/${type}/comment/create/'),
    body: json.encode({"post":postId,"comment":commentText}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=201){
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Error', Icon(Icons.close), false));
      // throw Exception(response.body);
    } else {
      final newComment = PostComment.fromJson(jsonDecode(response.body));
      comments.add(newComment);
      notifyListeners();
    }
  }

  Future<void> DeleteData(String type, String commentId, BuildContext context) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/${type}/comment/${commentId}/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      print(commentId);
      comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( 'Comment deleted', Icon(Icons.delete), true));

    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
  // void
}

class TimestampCommentProvider extends ChangeNotifier{
  List<PostComment> _comments = [];
  List<PostComment> get comments => _comments;
  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;
  int _page = 1;
  int get page => _page;

  // Future<void> addComment(String type, int postId, String commentText) async {
  //   postData(type, postId, commentText);
  //   notifyListeners();
  // }

  void remove(int commentId) {
    comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }


  Future<void> fetchComments(int post) async {
    if (_nextPageUrl == 'null') {
      return;
    }
    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/ts/comment/list/?post=$post&page=$_page'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
          comments.addAll(List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson))));
          _page++;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> refreshComments(int post) async {

    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/ts/comment/list/?post=$post&page=1'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<PostComment> refreshList = List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson)));
        _comments = refreshList;
        _page = 2;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }


  Future<void> postData(String type, int postId, String commentText) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}api/ts/comment/create/'),
    body: json.encode({"post":postId,"comment":commentText}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=201){
      throw Exception(response.body);
    } else {
      final newComment = PostComment.fromJson(jsonDecode(response.body));
      comments.add(newComment);
      notifyListeners();
    }
  }

  Future<void> DeleteData(String type, int commentId, BuildContext context) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/ts/comment/${commentId}/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      print(commentId);
      comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( 'Comment deleted', Icon(Icons.delete), true));

    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
  // void
}

class ReviewCommentProvider extends ChangeNotifier{
  List<PostComment> _comments = [];
  List<PostComment> get comments => _comments;
  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;
  int _page = 1;
  int get page => _page;

  // Future<void> addComment(String type, int postId, String commentText) async {
  //   postData(type, postId, commentText);
  //   notifyListeners();
  // }

  void remove(int commentId) {
    comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }


  Future<void> fetchComments(int post) async {
    if (_nextPageUrl == 'null') {
      return;
    }
    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/rating/comment/list/?post=$post&page=$_page'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
          comments.addAll(List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson))));
          _page++;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> refreshComments(int post) async {

    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/rating/comment/list/?post=$post&page=1'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<PostComment> refreshList = List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson)));
        _comments = refreshList;
        _page = 2;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch (e) {
            _nextPageUrl = 'null';
          }
            notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }


  Future<void> postData(int postId, String commentText) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}api/rating/comment/create/'),
    body: json.encode({"post":postId,"comment":commentText}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=201){
      throw Exception(response.body);
    } else {
      final newComment = PostComment.fromJson(jsonDecode(response.body));
      comments.add(newComment);
      notifyListeners();
    }
  }

  Future<void> DeleteData(int commentId, BuildContext context) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/rating/comment/${commentId}/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      print(commentId);
      comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( 'Comment deleted', Icon(Icons.delete), true));

    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
  // void
}

