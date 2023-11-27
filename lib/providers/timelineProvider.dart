import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class TimelineProvider extends ChangeNotifier{
  List<Timeline> _items = [];
  List<Timeline> get items => _items;
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


  Future<void> fetchData(BuildContext context) async {
      if (_nextPageUrl=='null'){
        return;
      }

      final cacheManager = DefaultCacheManager();
      final cacheData = await cacheManager.getFileFromCache('timeline_data');
      if (cacheData != null) {
        final decodedData = json.decode(await cacheData.file.readAsString());
        final cachedItems = List<Timeline>.from(decodedData['items'].map((itemJson) => Timeline.fromJson(itemJson)));
        final cachedNextPageUrl = decodedData['nextPageUrl'];

        _items.addAll(cachedItems);
        _nextPageUrl = cachedNextPageUrl;

        notifyListeners();
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}api/ts/list/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
          List<Timeline>.from(data['results'].map((postJson) => Timeline.fromJson(postJson)))
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
      final index = items.indexWhere((element) => element.id == id);
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

    Future<void> DeleteData(BuildContext context,String movie, int stamp) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      items.removeWhere((c) => c.movie == movie && c.stamp == stamp);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Deleted successfully', Icon(Icons.delete), true));
    } else {
      // Request failed
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
}