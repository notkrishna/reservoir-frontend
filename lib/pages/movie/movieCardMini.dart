import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;

class MovieCardMini extends StatefulWidget {
  final String id;
  // final String coverImgUrl;
  const MovieCardMini({Key? key, required this.id}): super(key: key);

  @override
  State<MovieCardMini> createState() => _MovieCardMiniState();
}

class _MovieCardMiniState extends State<MovieCardMini> {
  String _coverImgUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMovieSnippet(widget.id);
  }

  Future<MovieCardModel> _getMovieSnippet(String id) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}m/snippet/$id/'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = MovieCardModel.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception(response.headers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMovieSnippet(widget.id),
      builder: (context,snapshot) {
        if(snapshot.hasData){
          final dt = snapshot.data!;
          return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  id: widget.id,
                )
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(
                height: 175,
                width: 125,
                child: Image.network(
                  dt.coverImgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError){
          return Text('error');
        } else {
          return Container();
        }
      }
    );
  }
}