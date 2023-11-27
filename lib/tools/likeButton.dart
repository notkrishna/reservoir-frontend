import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:http/http.dart' as http;


class LikeButton extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  final String type;
  final String post;
  final BuildContext cxt;
  const LikeButton({
    super.key, 
    required this.isLiked,
    required this.likeCount,
    required this.type, 
    required this.post,
    required this.cxt,
    });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {


  // bool _widgetIsLiked = false;
  // int _widgetLikeCount = 0;

  bool _isLiked = false;
  int _likeCount = 0;


  @override
  void initState() {
    super.initState();
    _checkIfPostLiked();
    getLikeCount();
  }

  void _checkIfPostLiked() async {
    // String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    // final response = await http.get(
    //   Uri.parse('${Globals().url}api/${widget.type}/like/?post_id=${widget.post}'),
    //   headers: {
    //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
    //   },
    // );
    if (widget.isLiked){
      if(mounted){
          setState(() {
          _isLiked = true;
        });}      
    } else {
      if(mounted){
          setState(() {
          _isLiked = false;
        });} 
      // _isLiked = false;
    }
  }

  void _togglePostLike() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

    if(mounted){
      setState(() {
      _isLiked = !_isLiked;
      
    });}
    
    if (_isLiked) {
      response = await http.post(
        Uri.parse('${Globals().url}api/${widget.type}/like/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'post':widget.post,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}api/${widget.type}/like/?post_id=${widget.post}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
        
      );
    }

    if (response.statusCode == 201) {
      if (mounted){
        setState(() {
        _likeCount += 1;
      });}
    } else if (response.statusCode == 204) {
      if (mounted){
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
    // String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    // final response = await http.get(
    //   Uri.parse('${Globals().url}api/${widget.type}/like_count/?post_id=${widget.post}'),
    //   headers: {
    //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
    //   },
    // );
    // if (response.statusCode == 200){
    //   final data = jsonDecode(response.body) as Map<String,dynamic>;
    //   final likeCount = data["like_count"] as int;

      if(mounted){
        setState(() {
        _likeCount = widget.likeCount;
      });}
    // } else {
    //   throw Exception(response.body);
    // }
  }

  
  Widget build(BuildContext context) {
    // return widget.type == 'ts'
    // ? TextButton.icon(
    //   style: ElevatedButton.styleFrom(
    //     foregroundColor: Theme.of(context).iconTheme.color
    //     // backgroundColor: _isLiked==false ? Colors.transparent : Colors.pink,
    //   ),
    //   onPressed: _togglePostLike, 
    //   icon: Icon(_isLiked==false?Icons.favorite_border:Icons.favorite, size: 18,), 
    //   label: Text('${_likeCount}')
    // )
    // :
    return ElevatedButton.icon(
          onPressed: _togglePostLike,
          style: ElevatedButton.styleFrom(
            // backgroundColor:isButtonLiked==false ? Colors.transparent : Colors.pink,
            backgroundColor: _isLiked==false ? Colors.transparent : Color.fromARGB(255, 233, 30, 30),
          ),
          // onPressed: () {
          //   final pvdr = Provider.of<LikeButtonProvider>(context,listen:false);
            
          //   if (mounted){
          //     setState(() {
          //     isButtonLiked = !isButtonLiked;
          //     });
          //   }

          //   isButtonLiked 
          //   ?
          //   pvdr.likePost(widget.type, widget.post)
          //   :
          //   pvdr.unlikePost(widget.type, widget.post);

            
          //   }, 
          icon: Icon(_isLiked==false?Icons.favorite_border:Icons.favorite, size: 16,), 
          // icon: Icon(isButtonLiked==false?Icons.favorite_border:Icons.favorite, size: 16,), 
          label: Text('${_likeCount}',)
        ); 
    // Consumer<LikeButtonProvider>(
    //   builder: (context,provider,_) {
    //     bool isButtonLiked = provider.isLiked;

        
        // return ElevatedButton.icon(
        //   style: ElevatedButton.styleFrom(
        //     // backgroundColor:isButtonLiked==false ? Colors.transparent : Colors.pink,
        //     backgroundColor: _isLiked==false ? Colors.transparent : Color.fromARGB(255, 71, 30, 233),
        //   ),
        //   onPressed: _togglePostLike,
        //   // onPressed: () {
        //   //   final pvdr = Provider.of<LikeButtonProvider>(context,listen:false);
            
        //   //   if (mounted){
        //   //     setState(() {
        //   //     isButtonLiked = !isButtonLiked;
        //   //     });
        //   //   }

        //   //   isButtonLiked 
        //   //   ?
        //   //   pvdr.likePost(widget.type, widget.post)
        //   //   :
        //   //   pvdr.unlikePost(widget.type, widget.post);

            
        //   //   }, 
        //   icon: Icon(_isLiked==false?Icons.favorite_border:Icons.favorite, size: 16,), 
        //   // icon: Icon(isButtonLiked==false?Icons.favorite_border:Icons.favorite, size: 16,), 
        //   label: Text('${_likeCount}',)
        // );
    //   }
    // );
  
    // final post = Provider.of<HomepageProvider>(context);
    // return Consumer<HomepageProvider>(
    //   builder: (context,provider,_) {
    //     return ElevatedButton.icon(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor:widget.isLiked==false ? Colors.transparent : Colors.pink,
    //         // backgroundColor: _isLiked==false ? Colors.transparent : Color.fromARGB(255, 71, 30, 233),
    //       ),
    //       onPressed: (){
    //         Provider.of<HomepageProvider>(widget.cxt,listen:false).togglePostLike(widget.type, widget.post);
    //         }, 
    //       icon: Icon(widget.isLiked==false?Icons.favorite_border:Icons.favorite, size: 16,), 
    //       label: Text('${widget.likeCount}',)
    //     );
    //   }
    // );
  
  }

}