import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttert/models/searchModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/likeButtonProvider.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier{
  List<SearchModel> _results = [];
  List<SearchModel> get results => _results;
  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;
  int _page = 1;
  int get page => _page;

  

  // Future<void> addComment(String type, int postId, String commentText) async {
  //   postData(type, postId, commentText);
  //   notifyListeners();
  // }

  // void remove(int postId) {
  //   results.removeWhere((c) => c.id == postId);
  //   notifyListeners();
  // }

  Future<void> fetchPosts(BuildContext context, String ftext, bool reset) async {
    
    if(reset == true){
      _results.clear();
      _nextPageUrl = '';
      _page = 1;
    }

    if (_nextPageUrl == 'null') {
      return;
    }

    try {
      String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
          Uri.parse('${Globals().url}movieSearch/?page=$_page&search=$ftext'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
          results.addAll(List<SearchModel>.from(data['results'].map((commentJson) => SearchModel.fromJson(commentJson))));
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
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Couldn\'t load data', Icon(Icons.close), false));
    }
  }

  // Future<void> refreshPosts(BuildContext context) async {

  //   // final cacheManager = DefaultCacheManager();
  //   // final cacheData = await cacheManager.getFileFromCache('homepage_data');
  //   // if (cacheData != null) {
  //   //   final decodedData = json.decode(await cacheData.file.readAsString());
  //   //   final cachedItems = List<Tribe>.from(decodedData['items'].map((itemJson) => Tribe.fromJson(itemJson)));
  //   //   final cachedNextPageUrl = decodedData['nextPageUrl'];

  //   //   posts.addAll(cachedItems);
  //   //   _nextPageUrl = cachedNextPageUrl;

  //   //   notifyListeners();
  //   //   return;
  //   // }
  //   try {
  //     String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //         Uri.parse('${Globals().url}api/u/feed/?page=1'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $idToken',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //         List<Tribe> refreshedList = List<Tribe>.from(data['results'].map((commentJson) => Tribe.fromJson(commentJson)));
  //         _results = refreshedList;
  //         _page=2;
  //         print(_page);
  //         try {
  //           _nextPageUrl = data['next'] as String? ?? 'null';
  //         } catch (e) {
  //           _nextPageUrl = 'null';
  //         }
  //           notifyListeners();
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Couldn\'t load data', Icon(Icons.close), false));
  //   }
  // }


  // // Future<void> togglePostLike(String type, int post) async {
  // //   http.Response response;
  // //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  // //   int index = posts.indexWhere((element) => element.id==post);
    
  // //   bool _isl = posts[index].isLiked;
  // //   int _likeCount = posts[index].likeCount;
    
  // //   if (_isl == false) {
  // //     response = await http.post(
  // //       Uri.parse('${Globals().url}api/${type}/like/'),
  // //       headers: {
  // //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
  // //           'Content-Type':'application/json',
  // //       },
  // //       body:jsonEncode(
  // //         {
  // //           'post_id':post,
  // //         }
  // //       )
  // //     );
  // //   } else {
  // //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  // //     response = await http.delete(
  // //       Uri.parse('${Globals().url}api/${type}/like/?post_id=${post}'),
  // //       headers: {
  // //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
  // //       },
        
  // //     );
  // //   }

  // //   if (response.statusCode == 201) {
  // //       _isl = true;
  // //       _likeCount += 1;
  // //       print('+1');

  // //   } else if (response.statusCode == 204) {
  // //       _isl = false;
  // //       _likeCount -= 1;

  // //   } else {
        

  // //   }
  // //   notifyListeners();

  // // }

  // Future<void> DeleteData(String postId, BuildContext context) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(Uri.parse('${Globals().url}api/post/$postId/'),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     results.removeWhere((c) => c.id == postId);
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context,'Post deleted successfully', Icon(Icons.delete), true));  
  //     notifyListeners();
  //     // widget.onDelete();
  //   } else {
  //     // Request failed
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context,'Failed to delete post', Icon(Icons.close), false));  
  //     throw Exception('Failed to get JSON: ${response.reasonPhrase}');
  //     }
  //   }

  // Future<void> editData(context, String title, String caption, String id, String movie) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.put(Uri.parse('${Globals().url}api/post/$id/'),
  //   body: json.encode({'title':title, 'caption':caption, 'movie':movie}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=200){
  //     // ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Something went wrong', Icon(Icons.close), true));
  //     throw Exception(response.body);
  //   } else {
  //     final post = Tribe.fromJson(jsonDecode(response.body));
  //     final index = results.indexWhere((p) => p.id == id);

  //     if(index!=-1){
  //       results[index] = post;
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Post edited', Icon(Icons.check), true));
  //       Navigator.pop(context);
  //     } else {
  //       print('-1');
  //     }
  //     notifyListeners();
  //   }
  // }
  // void
}