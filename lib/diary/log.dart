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
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final _scrollController = ScrollController();
  int _page = 1;
  String _nextPageUrl = '';
  List<ProgressMovies> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchData();
      }

    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Future<void> fetchData() async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}progress/$id_token/?page=$_page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        if(mounted){
          setState(() {
          items.addAll(
            List<ProgressMovies>.from(
              data['results'].map((postJson) => ProgressMovies.fromJson(postJson)
              )
            )
          );
          _page++;
        // _isLoading = false;
          try {
            _nextPageUrl = data['next'];
          } catch(e) {
            _nextPageUrl = 'null';
          }
      });}
      } else {
        throw Exception(response.body);
      }
      // } else {
      //   return;
      // }
    }


  Widget build(BuildContext context) {
    return Padding(
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
                Expanded(
                  child: ListView.builder(
                            controller: _scrollController,
                            itemCount: items.length+1,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              if (index<items.length){
                                ProgressMovies item = items[index];
                                return Container();
                                // return ProgressCard(
                                //   id: item.movie
                                //   );
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
    );
  }
}