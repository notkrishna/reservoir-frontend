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
import 'package:fluttert/providers/commentProvider.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/tools/addPostButton.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';


class MoviePageTribe extends StatefulWidget {
  final String id;
  // final ScrollController scrollController;
  const MoviePageTribe({
    super.key, 
    required this.id, 
    // required this.scrollController
    }
  );

  @override
  State<MoviePageTribe> createState() => _MoviePageTribeState();
}

class _MoviePageTribeState extends State<MoviePageTribe> {
  final double fontSize = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<PostProvider>(context,listen:false);
    provider.fetchPosts(widget.id);
  }
  
  // @override
  // Future<void> fetchPosts() async {
  //     if (!_isLoading && _hasMorePosts) {
  //     if(mounted){
  //       setState(() {
  //       _isLoading = true;
  //     });}
  //     try {
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //     Uri.parse('${Globals().url}api/post/list/${widget.id}?page=$_page'),
  //       headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //           },
  //     );
  //     if (response.statusCode==200){
  //       final data = json.decode(response.body);
  //       if(mounted){
  //         setState(() {
  //         posts.addAll(List<Tribe>.from(data['results'].map((postJson) => Tribe.fromJson(postJson))));
  //         _page++;
  //       // _isLoading = false;
  //         try {
  //           _hasMorePosts = data['next'] != null;
  //         } catch(e) {
  //           _hasMorePosts = false;
  //         }
  //     });}
  //     } else {
  //       throw Exception(response.body);
  //     }
      
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     if(mounted){
  //       setState(() {
  //       _isLoading = false;
  //       });}
  //     }
  //   }
  //     // } else {
  //     //   return;
  //     // }
  //   }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context,listen: false);

    return Container(
      child: Scaffold(
        floatingActionButton: AddPostButton(
          movie: widget.id,
          cxt: context,
        ),
        body: 
        NotificationListener<ScrollNotification>(
          onNotification: (notification){
            if(notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
              provider.fetchPosts(widget.id);
              print('scroller works');
            }
            return false;
          },
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeadingWidget(heading: 'Posts'),
              SizedBox(height: 10,),
              Expanded(
                child: Consumer<PostProvider>(
                  builder: (context, provider, _) {
                    return
                    ListView.builder(
                              // controller: _scrollController,
                              itemCount: provider.posts.length+1,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                if (index<provider.posts.length){
                                  Tribe item = provider.posts[index];
                                  return 
                                  // provider.inProgress?
                                  
                                  // WidgetsBinding.instance?.addPostFrameCallback((_) {
                                  //   showDialog(context: context, builder: builder)
                                  // })

                                  // :
                                  
                                  MoviePostCard(
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
                                    pway: 'tribe',
                                    onDelete: (postId) {
                                      Provider.of<PostProvider>(context, listen: false).DeleteData(item.id, context);
                                    },
                                    // onDelete: (){
                                    //   if(mounted){
                                    //   setState(() {
                                    //     posts.removeAt;
                                    //   });
                                    //  };
                                    // }
                                    // user: item.user,
                                    // post_title: item.title,
                                    // post_content: item.caption, 
                                    // time_posted: '23m ago', 
                                    // movie: item.movie,
                                    // photoUrl: item.photoUrl,
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: 
                                            SizedBox(height: 0,),
                                    );
                                  }
                              },
                            );
                  }
                )
                    
              ),
            ],
          ),
        ),
        )
        
        
      ),
    );
  }


                                    
  // Future<List<Tribe>> fetchStamps(int movie) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/post/list/$movie'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //   );
  //   if (response.statusCode==200){
  //     if (response.body.isEmpty){
  //       throw Exception('Nothing here');
  //     } else {
  //       return (json.decode(response.body) as List)
  //       .map((data) => Tribe.fromJson(data))
  //       .toList();
  //     }
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }
}
