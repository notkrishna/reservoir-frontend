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
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieListAdd.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/pages/movie/movieStatHead.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MoviePageAbout extends StatefulWidget {
  final String id;
  const MoviePageAbout({super.key, required this.id});

  @override
  State<MoviePageAbout> createState() => _MoviePageAboutState();
}
class _MoviePageAboutState extends State<MoviePageAbout> {
  late Future<Movie> futureMovie;
  late Future<bool> MovieSaved;
  final double fontSize = 18;
  Color themeColor = Color.fromARGB(255, 255, 1, 1);

  Movie movie = Movie(
    id: '', 
    // imgUrl: 'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=', 
    movieName: '', 
    description: '', 
    // year: 1000, 
    duration: 0, 
    // isShow: false, 
    coverImgUrl: 'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
    saved: false,
    progress: false,
    following: false,
    userHasCover: false
    );

  bool _isMovieSaved = false;
  bool _isMovieTracked = false;
  bool _isMovieFollowed = false;

  @override
  void initState() {
    super.initState();
    // _checkIfMovieSaved();
    // _checkIfMovieTracked();
    // _checkIfMovieFollowed();
    fetchMovie(widget.id);
    // _btnStates();
  } 

  @override
  void _btnStates() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}m/mbtnstates/?movie=${widget.id}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _isMovieSaved = data['saved'] as bool;
          _isMovieFollowed = data['follow'] as bool? ?? false;
          _isMovieTracked = data['progress'];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( '', Icon(Icons.close), false));
    }
  }

  Future<void> fetchMovie(String id) async{
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}m/${id}/'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = Movie.fromJson(
        jsonDecode(response.body)
      );
      if (mounted){
        setState(() {
          movie = data;
          _isMovieSaved = movie.saved;
          _isMovieTracked = movie.progress;
          _isMovieFollowed = movie.following;
        });
      }
    } else {
      throw Exception(response.body);
    }
  }


  // void _checkIfMovieSaved() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}saved/${widget.id}'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body);
  //     if (data.length==0){
  //       _isMovieSaved = false;
  //     } else {
  //       if(mounted){
  //         setState(() {
  //         _isMovieSaved = true;
  //       });}
  //     }
  //   } else {
  //     _isMovieSaved = false;
  //   }
  // }

  // void _checkIfMovieFollowed() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}m/follow/${widget.id}'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body);
  //     if (data.length==0){
  //       _isMovieFollowed = false;
  //     } else {
  //       if(mounted){
  //         setState(() {
  //         _isMovieFollowed = true;
  //       });}
  //     }
  //   } else {
  //     _isMovieFollowed = false;
  //   }
  // }


  // void _checkIfMovieTracked() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}progress/${widget.id}'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body);
  //     if (data.length==0){
  //       _isMovieTracked = false;
  //     } else {
  //       if(mounted){
  //         setState(() {
  //         _isMovieTracked = true;
  //       });}
  //     }
  //   } else {
  //     _isMovieTracked = false;
  //   }
  // }

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
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Failed', Icon(Icons.close), false));
      if(mounted){
        setState(() {
        _isMovieSaved = !_isMovieSaved;
      });}
    } else if(response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Saved to watchlist', Icon(Icons.bookmark), true));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Removed from watchlist', Icon(Icons.delete), true));

    }
  }

  void _toggleMovieFollowed() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

   if(mounted){
    setState(() {
      _isMovieFollowed = !_isMovieFollowed;
    });}
    
    if (_isMovieFollowed) {
      response = await http.post(
        Uri.parse('${Globals().url}m/follow/create/'),
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
        Uri.parse('${Globals().url}m/follow/${widget.id}/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    }

    if (response.statusCode != (_isMovieFollowed ? 201 : 204)) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Failed', Icon(Icons.close), false));
      if(mounted){
        setState(() {
        _isMovieFollowed = !_isMovieFollowed;
      });}
    } else if(response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Followed movie', Icon(Icons.check), true));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Unfollowed movie', Icon(Icons.check), true));

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
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Tracking Progress', Icon(Icons.check), true));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Removed from Progress', Icon(Icons.delete), true));

    }
  }


  @override
  Widget build(BuildContext context) {
    // String mors = movie.isShow?'Show':'Movie';

    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder(
            //   future:fetchMovie(widget.id),
            //   builder:(context, snapshot) {
            //     if (snapshot.hasData) {
            //       Movie dt = snapshot.data!;
            Column(
              children: [
                // MovieCard(
                //   id: movie.id, 
                //   height: 80
                // ),
                MoviePageImg(
                  imgUrl: movie.coverImgUrl,
                  title: movie.movieName,
                  id: movie.id,
                  userHasCover: movie.userHasCover,
                ),
            MovieStatsHead(avg_rating: movie.avg_rating, rating_count: movie.rating_count,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleMovieFollowed, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                        ),
                        child: Text(_isMovieFollowed==false?'Follow':'Following')
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: (){

                      //   }, 
                      //   icon: Icon(Icons.play_arrow, size: 18,),
                      //   label: Text('Trailer'),
                      // ),
                      // Text('${dt[1]}'),
                      ElevatedButton.icon(
                        onPressed:(){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => MovieListAdd(movie: widget.id,))
                          );
                        },
                        icon:Icon(Icons.playlist_add),
                        label: Text('List'),
                      ),

                      ElevatedButton(
                        onPressed:_toggleMovieSaved, 
                        child:_isMovieSaved==false?Icon(Icons.bookmark_add_outlined):Icon(Icons.bookmark)
                      ),
                      
                      ElevatedButton(
                        onPressed: 
                          _toggleMovieTracked,
                        child:_isMovieTracked==false?Icon(Icons.alarm_add):Icon(Icons.timer)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder:(context) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Description'),
                            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close), iconSize: 18,)
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: Text(
                            movie.description,
                            style: TextStyle(
                            fontFamily: 'oswald',
                            fontSize: 13,
                    // color: Color.fromARGB(255, 216, 216, 216),
                  ),
                  textAlign: TextAlign.justify,
                            )
                          ),
                      ),
                    );
                  }, 
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:30),
                width: 400,
                child: Text(
                  // textColor: Colors.grey,
                  // limit: 10,
                  movie.description.length>220
                  ?movie.description.substring(0,221) + ' . . .'
                  :movie.description,
                  style: TextStyle(
                    fontFamily: 'oswald',
                    fontSize: 13,
                    // color: Color.fromARGB(255, 216, 216, 216),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:30, vertical: 5),
              width: 400,
              child: Text(
               '${movie.duration} minutes',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                // color: Color.fromARGB(255, 216, 216, 216),
                fontWeight:FontWeight.bold,
              ),
              
              textAlign: TextAlign.justify,
            ),
          ),
          

                    ],
                  )
            //     } else if (snapshot.hasError) {
            //       return Text('${snapshot.error}');
            //     }
            //     return Loading(y: 0.1,x: 0.5,);
            //   },    
            // ),
           
          ],
         ),
        )
      
    );
  }
}