// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:fluttert/models/TimelineModel.dart';
// import 'package:fluttert/models/movieModel.dart';
// import 'package:fluttert/models/tribeModel.dart';
// import 'package:fluttert/pages/globals.dart';
// import 'package:http/http.dart' as http;

// class LikeButtonProvider extends ChangeNotifier{
//   bool _isLiked = false;
//   int _likeCount = 0;

//   LikeButtonProvider({required bool isLiked, required int likeCount})
//     : _isLiked = isLiked,
//       _likeCount = likeCount;

//   bool get isLiked => _isLiked;
//   int get likeCount => _likeCount;


//   // Future<void> addComment(String type, int postId, String commentText) async {
//   //   postData(type, postId, commentText);
//   //   notifyListeners();
//   // }

//   // void remove(int postId) {
//   //   posts.removeWhere((c) => c.id == postId);
//   //   notifyListeners();
//   // }


//   Future<void> likePost(String type, String post) async {
//     http.Response response;
//     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

//     _isLiked = !_isLiked;

//     response = await http.post(
//         Uri.parse('${Globals().url}api/${type}/like/'),
//         headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $id_token',
//             'Content-Type':'application/json',
//         },
//         body:jsonEncode(
//           {
//             'post_id':post,
//           }
//         )
//       );
//       if (response.statusCode == 201) {
//         _likeCount += 1;

//       } else {
//           _isLiked = !_isLiked;

//       }
//       notifyListeners();
//   }

//   Future<void> unlikePost(String type, String post) async {
//     http.Response response;
//     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

//     _isLiked = !_isLiked;

//     response = await http.delete(
//       Uri.parse('${Globals().url}api/${type}/like/?post_id=${post}'),
//       headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//       },
      
//     );
//     if (response.statusCode == 204) {
//         _likeCount -= 1;

//     } else {
//         _isLiked = !_isLiked;
//     }
//     notifyListeners();
//   }


//   // Future<void> togglePostLike(String type, int post) async {
//   //   http.Response response;
//   //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

//   //   _isLiked = !_isLiked;
    
//   //   if (_isLiked) {
//   //     response = await http.post(
//   //       Uri.parse('${Globals().url}api/${type}/like/'),
//   //       headers: {
//   //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//   //           'Content-Type':'application/json',
//   //       },
//   //       body:jsonEncode(
//   //         {
//   //           'post_id':post,
//   //         }
//   //       )
//   //     );
//   //   } else {
//   //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//   //     response = await http.delete(
//   //       Uri.parse('${Globals().url}api/${type}/like/?post_id=${post}'),
//   //       headers: {
//   //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//   //       },
        
//   //     );
//   //   }

//   //   if (response.statusCode == 201) {
//   //       _likeCount += 1;

//   //   } else if (response.statusCode == 204) {
//   //       _likeCount -= 1;

//   //   } else {
//   //       _isLiked = !_isLiked;

//   //   }
//   //   notifyListeners();

//   // }
// }