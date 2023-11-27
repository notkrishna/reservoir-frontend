import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class TrendingList extends StatefulWidget {
  final String query;
  const TrendingList({super.key, required this.query});

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  late Future<List<MovieCardModel>> futureMovieList;
  
  @override
  void initState() {
    super.initState();
    futureMovieList = fetchMovieList();
  }

  Future<List<MovieCardModel>> fetchMovieList() async{
  try {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}movieSearch/?search=${widget.query}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final List result = json.decode(response.body);
      return result.map((e) => MovieCardModel.fromJson(e)).toList();
    } else {
      throw response.body;
    }
  } catch (e) {
    throw Exception(e);
  }
}
   
  @override
  Widget build(BuildContext context) {
      return Container(
              height: 200,
              child: FutureBuilder(
                future: futureMovieList,
                builder:(BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.isEmpty){
                      return Center(child: Text('Oops try again in a while!'));
                    }
                    List<MovieCardModel> dt = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dt.length,
                      itemBuilder: (context,index) {
                        return movieCard(dt[index].coverImgUrl);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Something went wrong!');
                  } else {
                    return Transform.scale(
                      scale:0.1,
                      child: Loading(x: 0.5,y: 0.1,),
                    );
                  }
                },
              ),
            );
  }
  Widget movieCard(String coverImgUrl){
    return Image.network(
      coverImgUrl,
      width: 125,
      height: 175,
      fit: BoxFit.cover,
    );
  }
}