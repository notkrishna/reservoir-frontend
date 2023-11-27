import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
import 'package:fluttert/diary/dialoguebox.dart';
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
import 'package:fluttert/tools/addPostButton.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;


class MovieListAdd extends StatefulWidget {
  final String movie;
  // final int id;
  // final ScrollController scrollController;
  const MovieListAdd({
    super.key, 
    required this.movie,
    // required this.id, 
    // required this.scrollController
    }
  );

  @override
  State<MovieListAdd> createState() => _MovieListAddState();
}

class _MovieListAddState extends State<MovieListAdd> {
  final double fontSize = 25;
  List<bool> _isChecked = [];
  // final _scrollController = ScrollController();
  int _page = 1;
  String _nextPageUrl = '';
  List<MovieList> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
    // _scrollController = widget.scrollController;

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     fetchPosts();
    //   }

    // });
  }
  
  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Future<void> fetchPosts() async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
      Uri.parse('${Globals().url}mls/check/?m=${widget.movie}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        if(mounted){
          setState(() {
          posts.addAll(List<MovieList>.from(data['results'].map((postJson) => MovieList.fromJson(postJson))));
          _page++;
        // _isLoading = false;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch(e) {
            _nextPageUrl = 'null';
          }
      });}


        // parsed['results'].forEach((commentJson) => comments.add(PostComment.fromJson(commentJson)));
        // _page++;
        // return comments;

        // final decoded = json.decode(response.body);
        // _page++;
        // final List<PostComment> comments = (decoded['results'] as List)
        // .map((data) => PostComment.fromJson(data))
        // .toList();
      } else {
        throw Exception(response.body);
      }
      // } else {
      //   return;
      // }
    }

  bool _isScrolledToBottom(ScrollNotification notification) {
    final metrics = notification.metrics;
    return metrics.pixels >= metrics.maxScrollExtent;
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      //   onPressed: () {
      //     showDialog(
      //       context: context, 
      //       builder: (context) => MovieListDialogueBox()
      //       );
      //   },
      //   icon: Icon(Icons.playlist_add),
      //   label: Text('Create List'),
      //   ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (notification){
          if(_isScrolledToBottom(notification)) {
            fetchPosts();
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
              child: ListView.builder(
                        // controller: _scrollController,
                        itemCount: posts.length+1,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          if (index<posts.length){
                            MovieList item = posts[index];
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.grey,
                              value: item.isInMovie,
                              onChanged: (value){
                                if(mounted){
                                  setState(() {
                                    item.isInMovie = value!;
                                  });
                                };
                                if(item.isInMovie==true){
                                  addRequest(item.id);
                                } else{
                                  removeRequest(item.id);
                                }
                              },
                            title: Text(item.listName),
                          );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: _nextPageUrl!='null'?
                                      Loading():
                                      SizedBox(height: 0,),
                              );
                            }
                        },
                      )
            ),
          ],
        ),
      ),
      )
    );
  
  }

  void removeRequest(String list_id) async{
    final String base_url = '${Globals().url}mls/d/?action=remove&movie=${widget.movie}&id=$list_id';
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse(base_url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        'Content-Type':'application/json; charset=utf-8',
        }
      );
    if(response.statusCode!=204){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Removed from list', Icon(Icons.check), true));
      // Navigator.pop(context);
    }
  }


  void addRequest(String list_id) async {
    final String base_url = '${Globals().url}mls/d/?action=add';
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(
        Uri.parse(base_url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
          'Content-Type':'application/json; charset=utf-8',

          },
        body: jsonEncode({'movie':widget.movie,'id':list_id}),
        );
      if(response.statusCode!=201){
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
        throw Exception(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Added to list', Icon(Icons.playlist_add), true));
        // Navigator.pop(context);
      }
    }

}