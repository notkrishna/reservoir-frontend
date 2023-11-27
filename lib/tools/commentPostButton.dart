import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentCard.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/commentProvider.dart';
import 'package:fluttert/tools/commentList.dart';
import 'package:fluttert/tools/commentPostCard.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CommentPostButtonWidget extends StatefulWidget {
  final String type;
  final String post;
  final int commentCount;
  CommentPostButtonWidget({super.key, required this.type, required this.post, required this.commentCount});
  @override
  _CommentPostButtonWidgetState createState() => _CommentPostButtonWidgetState();
}

class _CommentPostButtonWidgetState extends State<CommentPostButtonWidget> {

  TextEditingController _controller = TextEditingController();
  int _count = 0;

  // void getCommentCount() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/${widget.type}/comment/comment_count/?post_id=${widget.post}'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body) as Map<String,dynamic>;
  //     final count = data["comment_count"] as int;

  //     if(mounted){setState(() {
  //       _count = count;
  //     });}
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }
  
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => 
                  ChangeNotifierProvider(
                    create: (context) => CommentProvider(),
                    child: CommentList(type: widget.type, post: widget.post))
                )
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.transparent,
              backgroundColor: Colors.transparent,
              //shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(15),
              ),
            ),
            
              icon: Icon(Icons.chat_bubble_outline, size: 15,), 
              label: Text(
                '${widget.commentCount}',
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontFamily: 'Outfit'
                ),
              
              ),
          );
  }
}