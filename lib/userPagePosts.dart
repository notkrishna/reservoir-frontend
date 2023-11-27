import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/moviePostCard.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/providers/userPagePostsProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class UserPostPage extends StatefulWidget {
  final String user;
  const UserPostPage({super.key, this.user = ''});

  @override
  State<UserPostPage> createState() => _UserPostPageState();
}

// class _UserPostPageState extends State<UserPostPage> {
//   final double fontSize = 25;
//   // final _scrollController = ScrollController();
//   int _page = 1;
//   String _nextPageUrl = '';
//   List<Tribe> posts = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPosts();

//     // _scrollController.addListener(() {
//     //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//     //     fetchPosts();
//     //   }

//     // });
//   }
  
//   @override
//   void dispose() {
//     // _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Future<void> fetchPosts() async {
//       if (_nextPageUrl=='null'){
//         return;
//       }
//       String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//       final response = await http.get(
//       Uri.parse('${Globals().url}api/post/list/user/?page=$_page&u=${widget.user}'),
//         headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $id_token',
//             },
//       );
//       if (response.statusCode==200){
//         final data = json.decode(response.body);
//         if(mounted){
//           setState(() {
//           posts.addAll(List<Tribe>.from(data['results'].map((postJson) => Tribe.fromJson(postJson))));
//           _page++;
//         // _isLoading = false;
//           try {
//             _nextPageUrl = data['next'] as String? ?? 'null';
//           } catch(e) {
//             _nextPageUrl = 'null';
//           }
//       });}


//         // parsed['results'].forEach((commentJson) => comments.add(PostComment.fromJson(commentJson)));
//         // _page++;
//         // return comments;

//         // final decoded = json.decode(response.body);
//         // _page++;
//         // final List<PostComment> comments = (decoded['results'] as List)
//         // .map((data) => PostComment.fromJson(data))
//         // .toList();
//       } else {
//         throw Exception(response.body);
//       }
//       // } else {
//       //   return;
//       // }
//     }

//   bool _isScrolledToBottom(ScrollNotification notification) {
//     final metrics = notification.metrics;
//     return metrics.pixels >= metrics.maxScrollExtent;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Color.fromARGB(255, 0, 0, 0),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (notification){
//           if(_isScrolledToBottom(notification)) {
//             fetchPosts();
//           }
//           return false;
//         },
//         child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // HeadingWidget(heading: 'Posts'),
//             // SizedBox(height: 10,),
//             Expanded(
//               child: ListView.builder(
//                         // controller: _scrollController,
//                         itemCount: posts.length+1,
//                         padding: EdgeInsets.zero,
//                         itemBuilder: (context, index) {
//                           if (index<posts.length){
//                             Tribe item = posts[index];
//                             return MoviePostCard(
//                               id: item.id,
//                               // onDelete: (){
//                               //   removeListItem(index);
//                               // }
//                               // user: item.user,
//                               // post_title: item.title,
//                               // post_content: item.caption, 
//                               // time_posted: '23m ago', 
//                               // movie: item.movie,
//                               // photoUrl: item.photoUrl,
//                               );
//                             } else {
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: _nextPageUrl!='null' && index == posts.length
//                                       ?
//                                       Loading():
//                                       SizedBox(height: 0,),
//                               );
//                             }
//                         },
//                       )
                  
//             ),
//           ],
//         ),
//       ),
//       )
      
//     );
//   }

//   void removeListItem(int index) {
//     if(mounted){
//       setState(() {
//         posts.removeAt(index);
//         });
//       };
//   }

//   // Future<List<Tribe>> fetchStamps() async {
//   //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//   //   final response = await http.get(
//   //     Uri.parse('${Globals().url}api/post/list/user/?u=${widget.user}'),
//   //     headers: {
//   //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
//   //         'Content-Type': 'application/json',
//   //         },
//   //   );
//   //   if (response.statusCode==200){
//   //     if (response.body.isEmpty){
//   //       throw Exception('Nothing here');
//   //     } else {
//   //       return (json.decode(response.body) as List)
//   //       .map((data) => Tribe.fromJson(data))
//   //       .toList();
//   //     }
//   //   } else {
//   //     throw Exception(response.body);
//   //   }
//   // }
// }

class _UserPostPageState extends State<UserPostPage> {
  final double fontSize = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<UserPageProvider>(context,listen:false);
    provider.fetchPosts(widget.user);
    }

  // @override
  // Future<void> fetchPosts() async {
  //   if (!_isLoading && _hasMorePosts) {
  //     if(mounted){
  //       setState(() {
  //       _isLoading = true;
  //     });}

  //     try {
  //       String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
  //       final response = await http.get(
  //         Uri.parse('${Globals().url}api/post/list/user/?page=$_page&u=${widget.user}'),
  //         headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer $idToken',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         if(mounted){
  //           setState(() {
  //           posts.addAll(List<Tribe>.from(data['results'].map((postJson) => Tribe.fromJson(postJson))));
  //           _page++;

  //           try {
  //             _hasMorePosts = data['next'] != null;
  //           } catch (e) {
  //             _hasMorePosts = false;
  //           }
  //         });}
  //       } else {
  //         throw Exception(response.body);
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //     } finally {
  //       if(mounted){
  //         setState(() {
  //         _isLoading = false;
  //       });}
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserPageProvider>(context,listen: false);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter == 0) {
            provider.fetchPosts(widget.user);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Consumer<UserPageProvider>(
                  builder: (context,provider,_) {
                    return ListView.builder(
                      itemCount: provider.posts.length +1,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        if (index < provider.posts.length) {
                          Tribe item = provider.posts[index];
                          return MoviePostCard(
                            id: item.id,
                            user: item.user,
                            usertag: item.usertag,
                            profilePic: item.profilePic,
                            title: item.title,
                            caption: item.caption,
                            photoUrl: item.photoUrl,
                            postType: item.postType,
                            movie: item.movie,
                            postedAt: item.postedAt,
                            isLiked: item.isLiked,
                            likeCount: item.likeCount,
                            commentCount: item.commentCount,
                            cxt: context,
                            pway: 'userpage',
                            onDelete: (postId) async{
                              Provider.of<UserPageProvider>(context, listen: false).DeleteData(item.id, context);
                            },
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(height: 0,)
                          );
                        }
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
