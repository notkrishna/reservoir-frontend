import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/diary/progressCard.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/providers/progressProvider.dart';
import 'package:fluttert/providers/watchedProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Watchedpage extends StatefulWidget {
  final String userId;
  // final bool isUserPage;
  const Watchedpage({
    super.key,
    required this.userId,
    // this.isUserPage = false,
    });

  @override
  State<Watchedpage> createState() => _WatchedpageState();
}

class _WatchedpageState extends State<Watchedpage> {
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<WatchedProvider>(context,listen:false);
    provider.fetchData(widget.userId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchData(widget.userId);
      }
    });
  }

  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser!.uid;
    final bool isCurrUser = widget.userId == currUser;

    return Scaffold(
      appBar: !isCurrUser?
      AppBar(
        title: Text('Movies watched'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
      ):
      null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal:5.0),
                  //   child: HeadingWidget(heading: 'Progress'),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 5),
                    child: Text('Track and stamp the progress of your movies and shows.', style: TextStyle(color: Colors.grey),),
                  ),
                  // SizedBox(height: 15,),
                  // items.isNotEmpty == true
                  // ?
                  Expanded(
                    child: Consumer<WatchedProvider>(
                      builder: (context, provider, _) {
                        return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: provider.items.length+1,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    if (index<provider.items.length){
                                      ProgressMovies item = provider.items[index];
                                      return ProgressCard(
                                        id: item.id,
                                        movie: item.movie,
                                        duration: item.duration,
                                        lastStamp:item.lastStamp,
                                        coverImgUrl: item.coverImgUrl,
                                        movieName:item.movieName,
                                        isDoneWatching: item.isDone,
                                        // isUserPage: widget.isUserPage,
                                        user: widget.userId,
                                        cxt: context,
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
                        
                  )
                  // : SingleChildScrollView(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: MediaQuery.of(context).size.height/4,),
                  //       Icon(Icons.timer, size:50),
                  //       Padding(
                  //         padding: const EdgeInsets.all(15.0),
                  //         child: Text('Visit the movies you are watching and click on this icon to start tracking them.'),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  
                  
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: items.length,
                  //     itemBuilder: (context, index) {
                  //       ProgressMovies item = items[index];
                  //       return ProgressCard(id: item.movie);
                  //     }
                  //   ),
                  // ),
            //       Container(
            //   width: MediaQuery.of(context).size.width-20,
            //   child: Column(
            //             // crossAxisAlignment: CrossAxisAlignment.stretc,
            //             children: [
            //               Loading(x: 1,y: 1,),
            //               Align(
            //                 alignment: Alignment.bottomRight,
            //                 child: Loading(x: 0.5,y: 1,),
            //               )
                          
            //             ],
            //           ),
            // )
                ],
              )
        //     } else if (snapshot.hasError) {
        //       return Text('error');
        //     } 
        //     return Loading(x: 0.01, y: 0.5);
        //   },
        // ),
      ),
    );
  }

  Widget loadingContainer() {
    bool themeCond= Theme.of(context).scaffoldBackgroundColor==Colors.black;
    Color clr = themeCond?Color.fromARGB(255, 43, 43, 43):Color.fromARGB(255, 232, 232, 232);
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 10,
                color: clr,
              ),
              SizedBox(width: 10,),
              Container(
                // width: 20,
                height: 10,
                color: clr,
              ),
              SizedBox(width: 10,),
              Container(
                // width: 20,
                height: 30,
                color: clr,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Container(
                height: 100,
                color: clr,
              )
        ],
      ),
    );
  }

}
