import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:http/http.dart' as http;

class CommentPostCardWidget extends StatefulWidget {
  final String id;
  final String user;
  final String comment;
  final String usertag;
  final String profilePic;
  // final Animation<double> animation;
  final Function(String) onDelete;

  CommentPostCardWidget({
    super.key, 
    required this.id, 
    required this.user, 
    required this.comment,
    required this.usertag,
    required this.profilePic,
    // required this.animation,
    required this.onDelete,

    });
  @override
  _CommentPostCardWidgetState createState() => _CommentPostCardWidgetState();
}

class _CommentPostCardWidgetState extends State<CommentPostCardWidget> {
  String _usertag = 'username';
  String _photoUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getUserSnippet(widget.user);
  }
  
  // void _getUserSnippet(String user) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/u/snippet/$user/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     final usertag = data['usertag'] as String;
  //     final photoUrl = data['profile_pic'] as String;
      
  //     if(mounted){
  //       setState(() {
  //       _usertag = usertag;
  //       _photoUrl = photoUrl;
  //     });}
  //   } else {
  //     throw Exception(response.headers);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
  return ListTile(
    leading: CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(widget.profilePic),
    ),
    title: Text(
      widget.usertag,
      style: TextStyle(
        color: Color.fromARGB(255, 125, 125, 125), 
        fontFamily: 'Outfit', 
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),

    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      ExpandableText(
        limit: 300,
        text: widget.comment,
        textColor: Theme.of(context).iconTheme.color!
      ),
      // SizedBox(height: 10),
      // ButtonBar(
      //   alignment: MainAxisAlignment.start,
      //   children: [
      //     LikeButtonWidget(),
      //     TextButton.icon(
      //       onPressed: (){}, 
      //       icon: Icon(Icons.reply_outlined, size: 16,), 
      //       label: Text('Reply')
      //     )
      //   ],
      // )
    ]
    ),
    trailing: widget.user != FirebaseAuth.instance.currentUser!.uid
          ?
          Text('')
          :
          PopupMenuButton(
            iconSize: 15,
            color: Theme.of(context).colorScheme.secondary,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Edit'),
                value: 1,
                ),
              PopupMenuItem(
                child: Wrap(
                  children: [
                    Icon(Icons.delete, size: 20,),
                    Text(' Delete'),
                  ],
                ),
                value: 2,
                ),
              
            ],
            onSelected: (value) {
              if (value==1){
                // widget.popUp;
              }
              if (value ==2) {
                widget.onDelete(widget.id);
              };
            },
          ),
    );
  }
  
}