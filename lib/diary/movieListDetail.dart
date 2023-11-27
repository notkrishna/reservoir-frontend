import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
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
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/providers/listDetailProvider.dart';
import 'package:fluttert/tools/addPostButton.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/subtitle.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class MovieListDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String userId;
  // final ScrollController scrollController;
  const MovieListDetailPage({
    super.key, 
    required this.id, 
    required this.name,
    required this.userId,
    // required this.scrollController
    }
  );

  @override
  State<MovieListDetailPage> createState() => _MovieListDetailPageState();
}

class _MovieListDetailPageState extends State<MovieListDetailPage> {
  final double fontSize = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ListDetailProvider>(context, listen: false);
    provider.fetchData(widget.id);
    // _scrollController = widget.scrollController;

    // _scrollController.addListener(() {s
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     fetchprovider.items();
    //   }

    // });
  }

  // @override
  // Future<void> fetchprovider.items() async {
  //     if (_nextPageUrl=='null'){
  //       return;
  //     }
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //     Uri.parse('${Globals().url}mls/content/?list_id=${widget.id}&page=$_page'),
  //       headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //           },
  //     );
  //     if (response.statusCode==200){
  //       final data = json.decode(response.body);
  //       if(mounted){
  //         setState(() {
  //         posts.addAll(List<MovieListContent>.from(data['results'].map((postJson) => MovieListContent.fromJson(postJson))));
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
    final provider = Provider.of<ListDetailProvider>(context, listen: false);
    final currUser = FirebaseAuth.instance.currentUser!.uid;
    final bool isCurrUser = widget.userId==currUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        // title: ExpandableText(text: widget.name, limit: 20, textColor: Theme.of(context).iconTheme.color!,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      

      body: NotificationListener<ScrollNotification>(
        onNotification: (notification){
          if(_isScrolledToBottom(notification)) {
            provider.fetchData(widget.id);
          }
          return false;
        },
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HeadingWidget(heading: 'Posts'),
            // SizedBox(height: 10,),
            Expanded(
              child: Consumer<ListDetailProvider>(
                builder: (context,provider,_) {
                  return GridView.builder(
                    // controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // mainAxisSpacing: 0,
                      childAspectRatio: 1 / 2,
                      // crossAxisSpacing: 1
                    ),
                    itemCount: provider.items.length+1,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (index<provider.items.length){
                        MovieListContent item = provider.items[index];
                        return GestureDetector(
                          onLongPress: () {
                            isCurrUser == false?
                            null:
                            showModalBottomSheet(
                              context: context, 
                              builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.1,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        // height: MediaQuery.of(context).size.height*0.3,
                                        padding: EdgeInsets.all(10),
                                            child: Column(
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.delete, color: Colors.pink,),
                                                title: Text('Remove',style: TextStyle(color:Colors.pink,fontFamily: 'Outfit', fontSize: 20),),
                                                onTap: (){
                                                  removeData(item.id);
                                                  Navigator.pop(context);
                                                },
                                                //textColor: Colors.white,
                                                //iconColor: Colors.white,   
                                              ),
                                            ],
                                          )
                                          
                                        );
                              }
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => MoviePage(id: item.id))
                            );
                          },
                          // child:
                          // child: GridTile(
                          //   child: Stack(
                          //     fit: StackFit.expand,
                          //     children: [
                          //       Image.network(
                          //         item.coverPageUrl,
                          //         fit: BoxFit.cover,
                          //       ),
                          //       Positioned.fill(
                          //         child: BackdropFilter(
                          //           filter: ImageFilter.blur(sigmaX: 0,sigmaY: 20),
                          //           child: Container(),
                          //         )
                          //       ),
                          //       Positioned.fill(
                          //         child: Center(
                          //           child: Text('Title'),
                          //         )
                          //         )
                          //     ],
                          //   )
                          // ),
                          // child: movieCard(item.coverPageUrl)
                          child: MovieCard(
                            id: item.id,
                            height: 500,
                            movieName: item.movieName,
                            coverImgUrl: item.coverPageUrl,
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

  void removeData(String movieId){
    final provider = Provider.of<ListDetailProvider>(context, listen: false);
    provider.removeRequest(context, widget.id, movieId);
  }

  Widget movieCard(String coverImgUrl){
    return Ink.image(
      image: NetworkImage(coverImgUrl),
      width: 125,
      height: 175,
      fit: BoxFit.cover,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0,sigmaY: 15),
        child: const Center(
          child: Text(
            'Title'
            )
          )
        ),
    );
    // return Container(
    //   child: BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 0,sigmaY: 25),
    //     child: Image.network(
    //       coverImgUrl,
    //       width: 125,
    //       height: 175,
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
  }
  
  Future<String> getFilePath(movieId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${movieId}.jpg';
    return filePath;
  }
}


    
    // return userHasCover==true?
    //   FutureBuilder(
    //     future: getFilePath(movieId),
    //     builder:(context, snapshot) {
    //       if(snapshot.hasData){
    //         return Image.file(
    //           File(snapshot.data!),
    //           height: 200,
    //           width: 100,
    //           fit: BoxFit.cover,
    //           );
    //       } else if (snapshot.hasError) {
    //           return Image.network(
    //             coverImgUrl,
    //             height: 200,
    //             width: 125,
    //             fit: BoxFit.cover,
    //           );               
    //       } else {
    //         return CircularProgressIndicator();
    //       }
    //     },
    //   )
    //   :
    //   Image.network(
    //     coverImgUrl,
    //     height: 200,
    //     width: 125,
    //     fit: BoxFit.cover,
    //   );