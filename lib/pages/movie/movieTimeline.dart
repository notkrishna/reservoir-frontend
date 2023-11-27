import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/providers/movieTimelineProvider.dart';
import 'package:fluttert/providers/timelineProvider.dart';
import 'package:fluttert/tools/addTimestamp.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MovieTimeline extends StatefulWidget {
  final String id;
  const MovieTimeline({super.key, required this.id});

  @override
  State<MovieTimeline> createState() => _MovieTimelineState();
}

class _MovieTimelineState extends State<MovieTimeline> {
  TextStyle buttonText = TextStyle(
    //color: Colors.white,
    fontFamily: 'Outfit',
    fontSize: 15,
  );

  // int _page = 1;
  // String _nextPageUrl = '';
  // List<Timeline> posts = [];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MovieTimelineProvider>(context,listen:false);
    provider.fetchPosts(widget.id);
  }
  
  // @override
  // void dispose() {
  //   // _scrollController.dispose();
  //   super.dispose();
  // }

  bool _isScrolledToBottom(ScrollNotification notification) {
    final metrics = notification.metrics;
    return metrics.pixels >= metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieTimelineProvider>(context,listen:false);

    return Scaffold(
      floatingActionButton: AddTimestampButton(
        cxt: context,
        movie: widget.id,
      ),
      // 
      // 
      // FloatingActionButton.extended(
        
      //   heroTag: 'tsbtn',
      //   backgroundColor: Color.fromARGB(255, 255, 0, 0),
      //   onPressed: () {
      //     Navigator.push(
      //       context, 
      //       MaterialPageRoute(
      //         builder: (context) => 
      //         ChangeNotifierProvider(
      //           create: (_) => MovieTimelineProvider(),
      //           child: DialogueBox(
      //             req: "POST", 
      //             id: widget.id, 
      //             movie: widget.id,
      //             cxt: context
      //           ),
      //         )
      //       )
      //     );
      //     // fetchStamps(widget.id);         
      //   },
      //   icon: Icon(
      //     Icons.more_time,
      //     size: 22,
      //     ),
      //   label: Text('Add Timestamp',),
      //   ),
      //backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if(_isScrolledToBottom(notification)) {
            provider.fetchPosts(widget.id);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeadingWidget(heading: 'Timestamps'),
              SizedBox(height: 10,),
              Expanded(
                child: Consumer<MovieTimelineProvider>(
                  builder: (context, provider, _) {
                    return ListView.builder(
                          itemCount: provider.posts.length+1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index<provider.posts.length){
                              Timeline item = provider.posts[index];
                                return MovieTimelineStamp(
                                  onDiary: false,
                                  id: item.id,
                                  text: item.stampText,
                                  stamp: item.stamp, 
                                  user: item.user,
                                  movie: item.movie,
                                  movie_name: item.movie_name,
                                  usertag: item.usertag,
                                  commentCount: item.commentCount,
                                  likeCount: item.likeCount,
                                  isLiked: item.isLiked,
                                  cxt: context,
                                  pway: 'movie',
                                  onDelete: (tsId) {
                                    Provider.of<MovieTimelineProvider>(context, listen: false).DeleteData(context, widget.id, item.stamp);
                                  },
                                  );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: 
                                        SizedBox(height: 0,),
                                );
                              }
                            
                            }
                          );
                  }
                ),
              ),
            ],
          ),
        ),
      )
      
    );
  }
  // Future<void> fetchStamps(int movie) async {
  //   if (_nextPageUrl=='null'){
  //     return ;
  //   }
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/ts/list/m/$movie'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //   );
  //   if (response.statusCode==200){
  //       final data = json.decode(response.body);
  //       if(mounted){
  //         setState(() {
  //         posts.addAll(List<Timeline>.from(data['results'].map((postJson) => Timeline.fromJson(postJson))));
  //         _page++;
  //       // _isLoading = false;
  //         try {
  //           if (data['null'] == null){}
  //           _nextPageUrl = 'null';
  //           // _nextPageUrl = data['next'];
  //         } catch(e) {
  //           _nextPageUrl = 'null';
  //         }
  //     });}
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }
}