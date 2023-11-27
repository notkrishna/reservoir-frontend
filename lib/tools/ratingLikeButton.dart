import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;

class RatingLikeButton extends StatefulWidget {
  final String rating;
  const RatingLikeButton({super.key, required this.rating});

  @override
  State<RatingLikeButton> createState() => _RatingLikeButtonState();
}

class _RatingLikeButtonState extends State<RatingLikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  void initState() {
    super.initState();
    _checkIfRatingLiked();
    getLikeCount();
  }
  
  void _checkIfRatingLiked() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/rating/like/?rating_id=${widget.rating}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data.length == 0){
        _isLiked= false;
      } else {
        if(mounted){
          setState(() {
          _isLiked = true;
        });}
      }
    } else {
      _isLiked = false;
    }
  }

  void _toggleratingLike() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

    if(mounted){
      setState(() {
      _isLiked = !_isLiked;
    });}
    
    if (_isLiked) {
      response = await http.post(
        Uri.parse('${Globals().url}api/rating/like/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'rating_id':widget.rating,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}api/rating/like/?rating_id=${widget.rating}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
        
      );
    }

    if (response.statusCode == 201) {
      if(mounted){
        setState(() {
        _likeCount += 1;
      });}
    } else if (response.statusCode == 204) {
      if(mounted){
        setState(() {
        _likeCount -= 1;
      });}
    } else {
      if(mounted){
        setState(() {
        _isLiked = !_isLiked;
      });}
    }
  }

  void getLikeCount() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/rating/like_count/?rating_id=${widget.rating}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String,dynamic>;
      final likeCount = data["like_count"] as int;

      if(mounted){
        setState(() {
        _likeCount = likeCount;
      });}
    } else {
      throw Exception(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLiked==false ? Colors.transparent : Colors.pink
      ),
      onPressed: _toggleratingLike, 
      icon: Icon(_isLiked==false? Icons.favorite_border:Icons.favorite, size: 18,), 
      label: Text('${_likeCount}')
    );
  }

}