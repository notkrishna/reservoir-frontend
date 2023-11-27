import 'package:flutter/material.dart';
import 'package:fluttert/moviePostCard.dart';
import 'package:fluttert/postCardNotifs.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:provider/provider.dart';

class MoviePostPage extends StatefulWidget {
  final String post;
  const MoviePostPage({super.key, required this.post});

  @override
  State<MoviePostPage> createState() => _MoviePostPageState();
}

class _MoviePostPageState extends State<MoviePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child:Column(
            children: [
              PostCardNotifs(
                id: widget.post,
                onDelete: (postId) async{
                  Provider.of<PostProvider>(context, listen: false).DeleteData(widget.post, context);
                },
                // onDelete: (){
                  
                
                // }
              ),
            ],
          )
        ),
      ),
    );
  }
}