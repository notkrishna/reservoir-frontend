import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:http/http.dart' as http;

class CommentCardWidget extends StatefulWidget {
  final String id;
  final String user;
  final String usertag;
  final String comment;
  CommentCardWidget({super.key, required this.id, required this.user, required this.usertag, required this.comment});
  @override
  _CommentCardWidgetState createState() => _CommentCardWidgetState();
}
class _CommentCardWidgetState extends State<CommentCardWidget> {
  @override
  Widget build(BuildContext context) {
  return Card(
          elevation: 0,
          color: Colors.transparent,
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://hips.hearstapps.com/esquireuk.cdnds.net/15/37/original/original-hannibal-lecters-style-secrets-43-jpg-30df48d8.jpg'),
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
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  widget.user != FirebaseAuth.instance.currentUser!.uid
                  ?
                  Text('')
                  :
                  PopupMenuButton(
                    iconSize: 15,
                    color: Theme.of(context).colorScheme.secondary,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      // PopupMenuItem(
                      //   child: Text('Edit'),
                      //   value: 1,
                      //   ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 2,
                        ),
                      
                    ],
                    onSelected: (value) {
                      // if (value==1){
                      //   showDialog(
                      //     context: context, builder: (context) => ReviewDialogueBoxEdit(movie:widget.movie));
                      // }
                      if (value ==2) {
                        DeleteData();
                      };
                    },
                  )
                ],
              )
            ]
            )
          ),
        );
  }
  Future<void> DeleteData() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/rating/comment/${widget.id}/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      // Request was successful
        

    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
}