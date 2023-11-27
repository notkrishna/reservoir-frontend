import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
import 'package:fluttert/diary/MovieCardMiniStack.dart';
import 'package:fluttert/diary/MovieListDialogueEdit.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/diary/movieListDetail.dart';
import 'package:fluttert/diary/movieListDialogue.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/moviePostCard.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/providers/listDetailProvider.dart';
import 'package:fluttert/tools/addPostButton.dart';
import 'package:fluttert/tools/editList.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/subtitle.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/movieListProvider.dart';


class MovieListPage extends StatefulWidget {
  final String userId;
  // final int id;
  // final ScrollController scrollController;
  const MovieListPage({
    super.key, 
    required this.userId,

    // required this.id, 
    // required this.scrollController
    }
  );

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final double fontSize = 25;

  // final _scrollController = ScrollController();
  // int _page = 1;
  // String _nextPageUrl = '';
  // List<MovieList> provider.items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MovieListProvider>(context,listen:false);
    provider.fetchData(widget.userId);
    // _scrollController = widget.scrollController;

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     fetchprovider.items();
    //   }

    // });
  }
  
  // @override
  // Future<void> fetchPosts() async {
  //     if (_nextPageUrl=='null'){
  //       return;
  //     }
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //     Uri.parse('${Globals().url}mls/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //     );
  //     if (response.statusCode==200){
  //       final data = json.decode(response.body);
  //       if(mounted){
  //         setState(() {
  //         posts.addAll(List<MovieList>.from(data['results'].map((postJson) => MovieList.fromJson(postJson))));
  //         _page++;
  //       // _isLoading = false;
  //         try {
  //           _nextPageUrl = data['next'] as String? ?? 'null';
  //         } catch(e) {
  //           _nextPageUrl = 'null';
  //         }
  //     });}


  //       // parsed['results'].forEach((commentJson) => comments.add(PostComment.fromJson(commentJson)));
  //       // _page++;
  //       // return comments;

  //       // final decoded = json.decode(response.body);
  //       // _page++;
  //       // final List<PostComment> comments = (decoded['results'] as List)
  //       // .map((data) => PostComment.fromJson(data))
  //       // .toList();
  //     } else {
  //       throw Exception(response.body);
  //     }
  //     // } else {
  //     //   return;
  //     // }
  //   }

  bool _isScrolledToBottom(ScrollNotification notification) {
    final metrics = notification.metrics;
    return metrics.pixels >= metrics.maxScrollExtent;
  }

  @override

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieListProvider>(context, listen: false);
    final currUser = FirebaseAuth.instance.currentUser!.uid;
    final bool isCurrUser = widget.userId == currUser;

    return Scaffold(
      appBar: !isCurrUser?
      AppBar(
        title: Text('Lists'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
      ):
      null,

      floatingActionButton: isCurrUser?
      FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 56, 56, 56),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) => MovieListDialogueBox(
              onCreate:(lname) {
                provider.postData(context, lname);
              },
            )
            );
        },
        icon: Icon(Icons.playlist_add),
        label: Text('Create List',),
        ):
        null,

      body: NotificationListener<ScrollNotification>(
        onNotification: (notification){
          if(_isScrolledToBottom(notification)) {
            provider.fetchData(widget.userId);
          }
          return false;
        },
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HeadingWidget(heading: 'Posts'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 5),
              child: Text('Categorize your movie into lists.', style: TextStyle(color: Colors.grey),),
            ),            
            SizedBox(height: 10,),
            Expanded(
              child: Consumer<MovieListProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                            // controller: _scrollController,
                            itemCount: provider.items.length+1,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              if (index<provider.items.length){
                                MovieList item = provider.items[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => 
                                      ChangeNotifierProvider(
                                        create: (context) => ListDetailProvider(),
                                        child: MovieListDetailPage(
                                          name:item.listName,
                                          id: item.id,
                                          userId: widget.userId,
                                          )
                                        )
                                      )
                                    );
                                  },
                                  child: Container(
                                    // width:MediaQuery.of(context).size.width -20,

                                    // height: 200,
                                    // width: 120,
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // item.firstMovie.length>0? 
                                        // // MovieCardMini(id: item.firstMovie)
                                        // MovieCardMiniStack(
                                        //   m:item.firstMovie
                                        //   ) 
                                        // : 
                                        // SizedBox(height:175,width:130),
                                        // SizedBox(width: 5,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:MediaQuery.of(context).size.width -20,
                                              height: 140,
                                              child: HeadingWidget(
                                                heading: item.listName, 
                                                size: 50,
                                              )),

                                            // item.listName.length>100?
                                            // SizedBox.shrink():
                                            // SizedBox(height: 70,),
                                            // SubtitleWidget(text: 'description',size: 12,),
                                            // SizedBox(height: 20,),
                                            // SubtitleWidget(text:item.createdAt, size: 12,)
                                            isCurrUser == true?
                                            ButtonBar(
                                              alignment: MainAxisAlignment.start,
                                              children: [
                                                EditList(
                                                  cxt: context,
                                                  id: item.id,
                                                  lName: item.listName,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async{
                                                    showDialog(
                                                      context: context, 
                                                      builder:(context) {
                                                        return AlertDialog(
                                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                                          
                                                          shape: Border.all(
                                                            color: Theme.of(context).iconTheme.color!,
                                                            width: 2,
                                                          ),
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Delete list?')
                                                            ],
                                                          ),
                                                          actions: <Widget>[
                                                          TextButton(
                                                            onPressed: (){
                                                              Navigator.pop(context);
                                                            }, 
                                                            child: Text('Cancel')
                                                            ),
                                                          TextButton(
                                                            onPressed: (){
                                                              provider.deleteRequest(context,item.id);
                                                            }, 
                                                            child: Text('Confirm')
                                                            )
                                                          ]
                                                        );
                                                        
                                                        },
                                                      );
                                                  }, 
                                                  child: Icon(Icons.delete, size: 18,)
                                                )
                                              ],
                                            ):SizedBox.shrink(),
                                            SizedBox(height: 20,)
                                          ],
                                        ),
                                        // PopupMenuButton(
                                        //   iconSize: 15,
                                        //   color: Theme.of(context).colorScheme.secondary,
                                        //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                        //     PopupMenuItem(
                                        //       child: Text('Edit'),
                                        //       value: 1,
                                        //       ),
                                        //     PopupMenuItem(
                                        //       child: Text('Delete'),
                                        //       value: 2,
                                        //       ),
                                            
                                        //   ],
                                        //   onSelected: (value) {
                                        //     if (value==1){
                                        //       // Navigator.push(
                                        //       //   context, 
                                        //       //   MaterialPageRoute(builder: (context) => ReviewDialogueBoxEdit(movie:widget.movie))); 
                                                
                                        //     }
                                        //     else if (value ==2) {
                                        //       // DeleteData();
                                        //     };
                                        //   },
                                        // )

                                      ],
                                    )
                                  ),
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
      
      
    );
  }
  // void deleteRequest(int list_id) async{
  //   final String base_url = '${Globals().url}mls/d/?action=delete&id=$list_id';
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(
  //     Uri.parse(base_url),
  //     headers: {
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //       'Content-Type':'application/json; charset=utf-8',
  //       }
  //     );
  //   if(response.statusCode!=204){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' List deleted successfully', Icon(Icons.check), true));
  //     // Navigator.pop(context);
  //   }
  // }
}