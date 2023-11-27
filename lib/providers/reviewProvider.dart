import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieInfo.dart';
import 'package:http/http.dart' as http;

import '../models/ratingModel.dart';

class ReviewProvider extends ChangeNotifier{
  List<Rating> _items = [];
  List<Rating> get items => _items;
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


  Future<void> fetchData(BuildContext context, String userId) async {
      if (_nextPageUrl=='null'){
        return;
      }

      final cacheManager = DefaultCacheManager();
      final cacheData = await cacheManager.getFileFromCache('timeline_data');
      if (cacheData != null) {
        final decodedData = json.decode(await cacheData.file.readAsString());
        final cachedItems = List<Rating>.from(decodedData['items'].map((itemJson) => Rating.fromJson(itemJson)));
        final cachedNextPageUrl = decodedData['nextPageUrl'];

        _items.addAll(cachedItems);
        _nextPageUrl = cachedNextPageUrl;

        notifyListeners();
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/rating/list/user/?user=$userId'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
          List<Rating>.from(data['results'].map((postJson) => Rating.fromJson(postJson)))
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
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Couldn\'t load data', Icon(Icons.close), false));
        throw Exception(response.body);
      }
    }

  Future<void> editData(context, String movieId, int rating, String review) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(
    Uri.parse('${Globals().url}api/rating/$movieId/'),
    body: json.encode({
      'rating': rating,
      'review':review,
    }),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Something went wrong', Icon(Icons.close), true));
      throw Exception(response.body);
    } else {
      final ts = Rating.fromJson(jsonDecode(response.body));
      final index = items.indexWhere((element) => element.movie == movieId);
      if(index!=-1){
        items[index] = ts;
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Post edited', Icon(Icons.check), true));
        Navigator.pop(context);
        // notifyListeners();

      } else {
        print('-1');
      }
        notifyListeners();
    }
  }

  // Future<void> postData(BuildContext context, String lname) async { 
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}mls/d/?action=create'),
  //   body: json.encode({'list_name':lname}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error occured', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   } else {
  //     final moviels = MovieList.fromJson(jsonDecode(response.body));
  //     items.add(moviels);
  //     notifyListeners();
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' List created', Icon(Icons.list), true));
  //       Navigator.pop(context);
  //   }
  // }

    Future<void> DeleteData(BuildContext context,String movieId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse('${Globals().url}api/rating/${movieId}/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      items.removeWhere((c) => c.movie == movieId);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Deleted successfully', Icon(Icons.delete), true));
    } else {
      // Request failed
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
}