import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/main.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class PostProvider extends ChangeNotifier{
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

  Future<void> fetchPosts(String movieId) async {
    if (!_isLoading && _hasMorePosts) {
      _isLoading = true;


    try {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}api/post/list/${movieId}?page=$_page'),
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
        notifyListeners();

      }
    }
  }

  Future<void> postTextData(BuildContext context,String title, String caption, String movieId) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}api/post/create/'),
    body: json.encode({'title':title, 'caption':caption, 'movie':movieId}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Posting ...', Icon(Icons.pending), true));
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    if(response.statusCode==201){
      final newPost = Tribe.fromJson(jsonDecode(response.body));
      posts.insert(0,newPost);
      print('new post');
      notifyListeners();
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Post created successfully', Icon(Icons.edit), true));
      
      // int count=0;
      // Navigator.popUntil(context, (route) {
      //   count++;
      //   return count==3;
      // });

    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Error', Icon(Icons.close), true));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      throw Exception(response.body);
    }
  }

  Future<void> postImgData(BuildContext context, String title, String caption, String movieId, String imgPath) async {

    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    String url = '${Globals().url}api/post/create/';
    // final response = await http.post(Uri.parse('${Globals().url}api/post/create/'),
    // body: json.encode({'title':title, 'caption':caption, 'movie':widget.movie, 'post_type':'photo'}),
    // headers: {
    //     'Content-Type':'application/json; charset=utf-8',
    //     HttpHeaders.authorizationHeader: 'Bearer $id_token',
    //   },
    // );

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Set the authorization header
    request.headers['Authorization'] = 'Bearer $id_token';

    // Add the title field
    request.fields['title'] = title;

    // Add the captions field
    request.fields['caption'] = caption;
    request.fields['post_type'] = 'photo';


    request.fields['movie'] = movieId.toString();

    // Add the image file
    

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', 
        imgPath
        )
      );
    scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Posting ...', Icon(Icons.pending), true));
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);

    var response = await request.send();

      
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 2);

    if(response.statusCode==201){
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Post created successfully', Icon(Icons.edit), true));

      try {
        final newPost = Tribe.fromJson(jsonDecode(await response.stream.bytesToString()));
        posts.insert(0,newPost);
        print('new post');

      
        notifyListeners();
      } catch (e) {
        print(e);
      }
      
      
      // int count=0;
    //   Navigator.popUntil((route) {
    //   // Check if there are at least two routes remaining in the stack
    //   count++;
    //   return count==3;
    // });
    } else {
        scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Error occured', Icon(Icons.close), false));
        throw Exception(response.stream);
    }
  } 

  // Future<void> postData(String type, int postId, String commentText) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}api/${type}/comment/create/'),
  //   body: json.encode({"post":postId,"comment":commentText}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //     throw Exception(response.body);
  //   } else {
      
  //     notifyListeners();
  //   }
  // }

  Future<void> DeleteData(String postId, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg('Deleting ...', Icon(Icons.delete), true));  

    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/post/$postId/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg('Post deleted successfully', Icon(Icons.delete), true));  

     try {
       _posts.removeWhere((element) => element.id == postId);
      final ind = posts.indexWhere((c) => c.id == postId);
      // posts[ind] = Tribe(id: '', user: '', postType: '', usertag: '', profilePic: '', title: 'Post deleted', caption: '', movie: '', photoUrl: '', postedAt: '', isLiked: false, likeCount: 0, commentCount: 0);
      notifyListeners();
      } catch (e) {
        print(e);
      }
      // widget.onDelete();
    } else {
      // Request failed
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg('Failed to delete post', Icon(Icons.close), false));  
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
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Something went wrong', Icon(Icons.close), true));
      throw Exception(response.body);
    } else {
      final post = Tribe.fromJson(jsonDecode(response.body));
      final index = posts.indexWhere((element) => element.id == id);
      if(index!=-1){
        posts[index] = post;
        scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Post edited', Icon(Icons.check), true));
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