import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/providers/timelineProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});

  @override
  State<TimestampPage> createState() => _TimestampPageState();
}
    

class _TimestampPageState extends State<TimestampPage> {
  final _scrollController = ScrollController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<TimelineProvider>(context,listen:false);
    provider.fetchData(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchData(context);
      }
    });
  }
  

  // @override
  // Future<void> fetchPosts() async {
  //   try{
  //       if (_nextPageUrl=='null'){
  //       return;
  //       }
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/ts/list/'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //     if (response.statusCode==200){
  //         final data = json.decode(response.body);
  //         if(mounted){
  //           setState(() {
  //           posts.addAll(
  //             List<Timeline>.from(data['results'].map((postJson) => Timeline.fromJson(postJson)))
  //             );
  //           _page++;
  //         // _isLoading = false;
  //           try {
  //             _nextPageUrl = data['next'] as String? ?? 'null';
  //           } catch(e) {
  //             _nextPageUrl = 'null';
  //           }
  //         });}
  //     } else {
  //       throw Exception(response.body);
  //     }
  // } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Couldn\'t load data', Icon(Icons.close), false));
  //     }
  //     // } else {
  //     //   return;
  //     // }
  //   }
  
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal:5.0),
                  //   child: HeadingWidget(heading: 'Timestamps'),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 5),
                    child: Text(
                      'Stamp and describe moments you love in a movie or show.',
                       style: TextStyle(
                        color: Colors.grey
                        ),
                      ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Consumer<TimelineProvider>(
                      builder: (context, provider, _) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: provider.items.length+1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index<provider.items.length){
                              Timeline item = provider.items[index];
                                return MovieTimelineStamp(
                                  onDiary: true,
                                  id: item.id,
                                  text: item.stampText,
                                  stamp: item.stamp, 
                                  user: item.user,
                                  movie: item.movie,
                                  movie_name: item.movie_name,
                                  coverImgUrl: item.coverImgUrl,
                                  commentCount: item.commentCount,
                                  likeCount: item.likeCount,
                                  isLiked: item.isLiked,
                                  cxt: context,
                                  pway: 'diary',
                                  onDelete: (tsId) {
                                    provider.DeleteData(context, item.movie, item.stamp);
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
              )
              

    );
  }
}


