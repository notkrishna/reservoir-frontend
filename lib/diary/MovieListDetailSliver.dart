import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/moviePageImg.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieListAdd.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/pages/movie/movieStatHead.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:http/http.dart' as http;

class MovieListDetailSliverPage extends StatefulWidget {
  final String id;
  const MovieListDetailSliverPage({super.key, required this.id});

  @override
  State<MovieListDetailSliverPage> createState() => _MovieListDetailSliverPageState();
}
class _MovieListDetailSliverPageState extends State<MovieListDetailSliverPage> {
  late Future<Movie> futureMovie;
  late Future<bool> MovieSaved;
  final double fontSize = 18;
  Color themeColor = Color.fromARGB(255, 255, 1, 1);

  bool _isMovieSaved = false;
  bool _isMovieTracked = false;
  void initState() {
    super.initState();
    _checkIfMovieSaved();
    _checkIfMovieTracked();
  } 

  void _checkIfMovieSaved() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}saved/${widget.id}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data.length==0){
        _isMovieSaved = false;
      } else {
        if(mounted){
          setState(() {
          _isMovieSaved = true;
        });}
      }
    } else {
      _isMovieSaved = false;
    }
  }

  void _checkIfMovieTracked() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}progress/${widget.id}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data.length==0){
        _isMovieTracked = false;
      } else {
        if(mounted){
          setState(() {
          _isMovieTracked = true;
        });}
      }
    } else {
      _isMovieTracked = false;
    }
  }

  void _toggleMovieSaved() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

   if(mounted){
    setState(() {
      _isMovieSaved = !_isMovieSaved;
    });}
    
    if (_isMovieSaved) {
      response = await http.post(
        Uri.parse('${Globals().url}saved/create/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'movie_name':widget.id,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}saved/${widget.id}/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    }

    if (response.statusCode != (_isMovieSaved ? 201 : 204)) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Failed', Icon(Icons.close), false));
      if(mounted){
        setState(() {
        _isMovieSaved = !_isMovieSaved;
      });}
    } else if(response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Saved to watchlist', Icon(Icons.bookmark), true));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Removed from watchlist', Icon(Icons.delete), true));

    }
  }

  

  void _toggleMovieTracked() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

    if(mounted){
      setState(() {
      _isMovieTracked = !_isMovieTracked;
    });}
    
    if (_isMovieTracked) {
      response = await http.post(
        Uri.parse('${Globals().url}progress/create/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'movie':widget.id,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}progress/${widget.id}/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    }

    if (response.statusCode != (_isMovieTracked ? 201 : 204)) {
      if(mounted){
        setState(() {
        _isMovieTracked = !_isMovieTracked;
      });}
    } else if(response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Tracking Progress', Icon(Icons.check), true));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Removed from Progress', Icon(Icons.delete), true));

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future:fetchMovie(widget.id),
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                  Movie dt = snapshot.data!;
                  // String mors = dt.isShow?'Show':'Movie';
                  return Column(
                    children: [
                      MoviePageImg(
                        imgUrl: dt.coverImgUrl, 
                        title: dt.movieName,
                        id: dt.id,
                        userHasCover: dt.userHasCover,
                      ),
            // MovieStatsHead(avg_rating: dt.avg_rating, rating_count: dt.rating_count,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed:_toggleMovieSaved, 
                        icon:_isMovieSaved==false?Icon(Icons.bookmark_add_outlined):Icon(Icons.bookmark),
                        label: Text('Save List'),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal:30),
          //     width: 400,
          //     child: Text(
          //     dt.description,
          //     style: TextStyle(
          //       fontFamily: 'oswald',
          //       fontSize: 13,
          //       // color: Color.fromARGB(255, 216, 216, 216),
          //     ),
          //     textAlign: TextAlign.justify,
          //   ),
          // ),
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal:30, vertical: 5),
          //     width: 400,
          //     child: Text(
          //      '${dt.year} | G | ${dt.duration} minutes | $mors',
          //     style: TextStyle(
          //       fontFamily: 'Outfit',
          //       fontSize: 13,
          //       // color: Color.fromARGB(255, 216, 216, 216),
          //       fontWeight:FontWeight.bold,
          //     ),
              
          //     textAlign: TextAlign.justify,
          //   ),
          // ),
          

                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Loading(y: 0.1,x: 0.5,);
              },    
            ),
           
          ],
         ),
        )
      
    );
  }
}