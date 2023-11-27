
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';

class MovieCardMiniStack extends StatefulWidget {
  final List<dynamic> m;

  const MovieCardMiniStack({
    super.key,
    required this.m
    });

  @override
  State<MovieCardMiniStack> createState() => _MovieCardMiniStackState();
}

class _MovieCardMiniStackState extends State<MovieCardMiniStack> {
  @override
  Widget build(BuildContext context) {
    final mo = List.from(widget.m.reversed);
    return Container(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          
          movieCard(mo[0]),
          
          mo.length>=2?
          Positioned(
            right: 10,
            child: movieCard(mo[1]),
          )
          :SizedBox.shrink(),

          mo.length==3?
          Positioned(
            right: 20,
            child: movieCard(mo[2]),
          )
          :SizedBox.shrink(),  
        ],
      ),
    );
  }

  Widget movieCard(String coverImgUrl){
    // return Image.network(
    //   coverImgUrl,
    //   width: 125,
    //   height: 175,
    //   fit: BoxFit.cover,
    // );
    return ClipRect(
      child: Ink.image(
        image: NetworkImage(coverImgUrl),
        width: 125,
        height: 175,
        fit: BoxFit.cover,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20,sigmaY: 0),
          child: SizedBox.shrink()
          ),
      ),
    );
  }
}