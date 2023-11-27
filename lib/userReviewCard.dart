import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentButton.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/providers/likeButtonProvider.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/providers/reviewProvider.dart';
import 'package:fluttert/reviewDialogueBoxEdit.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/tools/likeButton.dart';
import 'package:fluttert/tools/ratingLikeButton.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:fluttert/tools/showRatingWidget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'tools/commentPostButton.dart';

class UserReviewCard extends StatelessWidget {
  final String id;
  final String movieId;
  final String movie;
  final int rating;
  final String review;
  final String userId;
  final String coverImgUrl;
  final BuildContext cxt;
  final int commentCount;
  final bool isLiked;
  final int likeCount;
  UserReviewCard({
    super.key, 
    required this.id, 
    required this.movieId, 
    required this.movie, 
    required this.rating, 
    this.review = "",
    required this.userId,
    required this.coverImgUrl,
    required this.cxt,
    required this.commentCount,
    required this.isLiked,
    required this.likeCount
    });

  String text = '';
  @override
  Widget build(BuildContext context) {
    text = review;
    final currUser = FirebaseAuth.instance.currentUser!.uid;
    final bool isCurrUser = userId == currUser;
    return Container(
      // leading: MovieCardMini(id: movie_id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MovieCard(
            id: movieId, 
            height: 50,
            coverImgUrl: coverImgUrl,
            movieName: movie,
          ),
          SizedBox(width: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // MovieCardMini(id: movie_id),
              // Expanded(
              //   child: Text(
              //     movie,
              //     style: TextStyle(
              //       fontSize: 20
              //     ),
              //     )
              // ),
              // SizedBox(width: 5,),
              ShowRatingWidget(
                color: Theme.of(context).iconTheme.color!,
                rating: rating,
              ),
              
            ],
          ),
          SizedBox(height: 10,),
          review != '' ? ExpandableText(text:text,limit: 490,textColor: Theme.of(context).iconTheme.color!,):SizedBox(height: 0,),
          
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              // ChangeNotifierProvider<LikeButtonProvider>(
              //     create: (context) => LikeButtonProvider(isLiked: isLiked, likeCount: likeCount),
              //     child: 
                  LikeButton(
                    isLiked: isLiked,
                    likeCount: likeCount,
                    type: 'rating',
                    post: id,
                    cxt: cxt,
                  ),
                // ),

              CommentPostButtonWidget(
                  type: 'rating', 
                  post: id, 
                  commentCount: commentCount,
                  ),
              
              isCurrUser == true?
              PopupMenuButton(
                iconSize: 15,
                color: Theme.of(context).colorScheme.secondary,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Edit'),
                    value: 1,
                    ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 2,
                    )
                ],
                onSelected: (value) {
                  if (value==1){
                    showDialog(
                      context: context, builder: (context) => ChangeNotifierProvider(
                        create:(context) => ReviewProvider(),
                        child: ReviewDialogueBoxEdit(
                          // id: id,
                          movie:movieId,
                          cxt: cxt,
                          pway: 'diary',
                        ),
                      )
                    );
                  }
                  else if (value ==2) {
                    Provider.of<ReviewProvider>(cxt,listen: false).DeleteData(context, movieId);
                  };
                },
              )
              :SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }
  // Future<void> DeleteData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(
  //     Uri.parse('${Globals().url}api/rating/${widget.movie_id}/'),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     // Request was successful
        

  //   } else {
  //     // Request failed
  //     throw Exception('Failed to get JSON: ${response.reasonPhrase}');
  //     }
  //   }
}