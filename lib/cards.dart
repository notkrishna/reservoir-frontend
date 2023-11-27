import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentButton.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/ratingWidget.dart';
class FeedCard extends StatefulWidget {
  final String user_avatar;
  final String user_background;
  final String username;
  final String movie_name;
  final String post_content;
  final String time_posted;
  final String like_count;
  final String comment_count;

  const FeedCard({super.key, required this.user_avatar, required this.user_background, required this.username, required this.movie_name, required this.post_content, required this.time_posted, required this.like_count, required this.comment_count});

  @override
  State<FeedCard> createState() => _FeedCardState();
}


class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) { 
    //width: MediaQuery.of(context).size.width*0.6,
    return Card(
      elevation: 0,
    //color: Color.fromARGB(255, 0, 0, 0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 0, 0, 0).withOpacity(0.7), 
              BlendMode.dstATop
              ),
            image: NetworkImage(widget.user_background),
            fit: BoxFit.cover,
          )
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        CircleAvatar(
            radius: 25, 
            backgroundImage: NetworkImage(
              widget.user_avatar),
                  ),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username, 
              style: TextStyle(
                //color: Colors.white,
                fontWeight: FontWeight.bold, 
                fontFamily: 'Outfit'),
            ),
            Text(
              widget.movie_name,
              style: TextStyle(
                //color: Color.fromARGB(255, 255, 255, 255),
                //fontWeight: FontWeight.bold,
                fontSize: 12,
                ),
            )
          ],
        ),
        ],
      )
      ),
    SizedBox(height: 10,),
    ExpandableText(
      limit: 300,
      text: widget.post_content,
      textColor: Theme.of(context).iconTheme.color!
    ),
    SizedBox(height: 5,),
    Text(
      widget.time_posted,
      style: TextStyle(
        //color: Color.fromARGB(255, 152, 152, 152), 
        fontFamily: 'Outfit',
        fontSize: 12
      ),
      textAlign: TextAlign.justify,
      ),
    ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: EdgeInsets.zero,
      children: [
        LikeButtonWidget(),
        // CommentButtonWidget(),
      ],
    )
    ],
    )
  );
  }
}