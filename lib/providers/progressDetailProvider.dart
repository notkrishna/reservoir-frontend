import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

import '../models/TimelineModel.dart';

class ProgressDetailProvider extends ChangeNotifier{
  List<ProgressDetail> _items = [];
  List<ProgressDetail> get items => _items;
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


  Future<void> fetchData(BuildContext context, String movieId, String userId) async {
      if (_nextPageUrl=='null'){
        return;
      }

      final cacheManager = DefaultCacheManager();
      final cacheData = await cacheManager.getFileFromCache('ProgressDetail_data');
      if (cacheData != null) {
        final decodedData = json.decode(await cacheData.file.readAsString());
        final cachedItems = List<ProgressDetail>.from(decodedData['items'].map((itemJson) => ProgressDetail.fromJson(itemJson)));
        final cachedNextPageUrl = decodedData['nextPageUrl'];

        _items.addAll(cachedItems);
        _nextPageUrl = cachedNextPageUrl;

        notifyListeners();
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}api/ts/list/progress/?movie=$movieId&user=$userId&page=$page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        items.addAll(
          List<ProgressDetail>.from(data['results'].map((postJson) => ProgressDetail.fromJson(postJson)))
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
      final ts = ProgressDetail.fromJson(jsonDecode(response.body));
      final index = items.indexWhere((element) => element.id == id);
      if(index!=-1){
        items[index] = ts;
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Post edited', Icon(Icons.check), true));
        int count = 0;
        Navigator.popUntil(
          context,
          (routed){
            count++;
            return count==3;
          }
        );
        // notifyListeners();

      } else {
        print('-1');
      }
        notifyListeners();
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
    if(response.statusCode!=201){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      final ts = ProgressDetail.fromJson(jsonDecode(response.body));
      items.insert(0,ts);
      notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Timestamp created', Icon(Icons.list), true));
        Navigator.pop(context);
    }
  }

  Future<void> DeleteData(BuildContext context, String id, String movie, int stamp) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      items.removeWhere((c) => c.id==id);
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Deleted successfully', Icon(Icons.delete), true));
    } else {
      // Request failed
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error occured', Icon(Icons.close), false));
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    notifyListeners();

    }
}