import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/reviewCard.dart';
import 'package:fluttert/reviewDialogueBox.dart';
import 'package:fluttert/reviewDialogueBoxEdit.dart';
import 'package:fluttert/tools/addReviewButton.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MoviePageReviews extends StatefulWidget {
  final String id;
  const MoviePageReviews({super.key, required this.id});

  @override
  State<MoviePageReviews> createState() => _MoviePageReviewsState();
}

class _MoviePageReviewsState extends State<MoviePageReviews> {
  bool isRated = false;
  Icon btnIcon = Icon(Icons.post_add, size: 22,);
  String btnText = 'Rate or Review';
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final provider = Provider.of<MovieReviewProvider>(context,listen:false);
    provider.fetchPosts(widget.id);
    // isRatedFn(widget.id);
  }
  // Future<void> isRatedFn(int movie) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/rating/$movie'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //   );
  //   if (response.statusCode==200){
  //     if(mounted){
  //       setState(() {
  //       isRated = true;
  //       btnText = 'Edit Review';
  //       btnIcon = Icon(Icons.edit,size:22);
  //     });}
  //   } else {
      
  //   }
  // }

  bool _isScrolledToBottom(ScrollNotification notification) {
    final metrics = notification.metrics;
    return metrics.pixels >= metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieReviewProvider>(context,listen:true);
    isRated = provider.isReviewed;
    return Scaffold(
      floatingActionButton: 
      AddReviewButton(
        // id: widget.id,
        movie: widget.id,
        isRated: isRated,
        cxt: context
        ),
      // FloatingActionButton.extended(
      //   backgroundColor: Color.fromARGB(255, 255, 0, 0),
      //   onPressed: () {
      //     isRated == false ?
      //     Navigator.push(
      //       context, 
      //       MaterialPageRoute(builder: (context) => ReviewDialogueBox(movie: widget.id,))
      //     ):
      //     Navigator.push(
      //       context, 
      //       MaterialPageRoute(builder: (context) => ReviewDialogueBoxEdit(movie: widget.id)) 
      //     );
      //   },
      //   icon: btnIcon,
      //   label: Text(btnText,),
      //   ),
      //backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if(_isScrolledToBottom(notification)) {
            provider.fetchPosts(widget.id);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeadingWidget(heading: 'Reviews'),
              SizedBox(height: 10,),
              Expanded(
                child: Consumer<MovieReviewProvider>(
                      builder: (context,provider,_) {
                        return ListView.builder(
                          itemCount: provider.posts.length+1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                              if (index<provider.posts.length){
                                Rating item = provider.posts[index];
                                return ReviewCard(
                                  isUserView: false,
                                  id: item.id,
                                  user: item.user,
                                  userProfilePic: item.userProfilePic,
                                  movie:item.movie,
                                  usertag: item.usertag,
                                  rating: item.rating,
                                  review: item.review,
                                  isLiked: item.isLiked,
                                  likeCount: item.likeCount,
                                  commentCount: item.commentCount,
                                  cxt: context,
                                );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: 
                                          SizedBox(height: 0,),
                                  );
                                }
                          },
                        );
                      }
                    ),
                    
              ),
            ],
          ),
        ),
      )
      
    );
  }
  
  // Future<List<Rating>> fetchRatings(int movie) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/rating/list/$movie'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //   );
  //   if (response.statusCode==200){
  //     return (json.decode(response.body) as List)
  //     .map((data) => Rating.fromJson(data))
  //     .toList();
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }
}