import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentButton.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/profilepage.dart';
import 'package:fluttert/providers/likeButtonProvider.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/reviewDialogueBoxEdit.dart';
import 'package:fluttert/tools/commentPostButton.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/tools/likeButton.dart';
import 'package:fluttert/tools/ratingLikeButton.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:fluttert/tools/showRatingWidget.dart';
import 'package:fluttert/userPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReviewCard extends StatefulWidget {
  final bool isUserView; 
  final String id;
  final String usertag;
  final int rating;
  final String review;
  final String movie;
  final String user;
  final String userProfilePic;
  final int commentCount;
  final bool isLiked;
  final int likeCount;
  final BuildContext cxt;
  const ReviewCard({
    super.key, 
    required this.isUserView, 
    required this.id, 
    required this.userProfilePic, 
    required this.user, 
    required this.usertag, 
    required this.rating, 
    this.review = "", 
    required this.movie,
    required this.commentCount,
    required this.isLiked,
    required this.likeCount,
    required this.cxt,
    });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(19, 255, 255, 255),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary, 
          width: 1
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.isUserView == false
            ? Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userProfilePic),
                  // backgroundColor: Colors.black,
                  radius: 15,
                  ),
                SizedBox(width: 5,),
                Expanded(
                  child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        FirebaseAuth.instance.currentUser!.uid == widget.user
                        ? ProfilePage()
                        : UserPage(
                            user: widget.user,
                        )
                      )
                    );
                  },
                  child: Text(widget.usertag,)
                  )
                ),
                SizedBox(width: 5,),
                ShowRatingWidget(
                  color: Colors.red,
                  rating: widget.rating,
                  
                ),
              ],
            )
            :
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // MovieCardMini(id: widget.movie_id),
                // Expanded(
                //   child: Text(
                //     widget.movie,
                //     style: TextStyle(
                //       fontSize: 20
                //     ),
                //     )
                // ),
                // SizedBox(width: 5,),
                ShowRatingWidget(
                  color: Theme.of(context).iconTheme.color!,
                  rating: widget.rating,
                ),
                
              ],
            ),
            SizedBox(height: 10,),
            widget.review != '' ? ExpandableText(text:widget.review,limit: 490,textColor: Theme.of(context).iconTheme.color!,):SizedBox(height: 0,),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                // ChangeNotifierProvider<LikeButtonProvider>(
                //   create: (context) => LikeButtonProvider(isLiked: widget.isLiked, likeCount: widget.likeCount),
                //   child:
                   LikeButton(
                    isLiked: widget.isLiked,
                    likeCount: widget.likeCount,
                    type: 'rating',
                    post: widget.id,
                    cxt: widget.cxt,
                  ),
                // ),

                CommentPostButtonWidget(
                  type: 'rating', 
                  post: widget.id, 
                  commentCount: widget.commentCount,
                  ),

                widget.user != FirebaseAuth.instance.currentUser!.uid
                ?
                PopupMenuButton(
                  iconSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    
                    PopupMenuItem(
                      child: Text('Report'),
                      value: 1,
                      )
                    
                  ],
                  onSelected: (value) {
                    
                  },
                )
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
                    PopupMenuItem(
                      child: Text('Report'),
                      value: 3,
                      )
                    
                  ],
                  onSelected: (value) {
                    // if (value==1){
                    //   Navigator.push(
                    //     context, 
                    //     MaterialPageRoute(builder: (context) => ReviewDialogueBoxEdit(
                    //       movie:widget.movie
                    //       ))); 
                        
                    // }
                    if (value ==2) {
                      Provider.of<MovieReviewProvider>(widget.cxt,listen: false).DeleteData(widget.movie, widget.id, context);
                    };
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  // Future<void> DeleteData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(
  //     Uri.parse('${Globals().url}api/rating/${widget.movie}/'),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     // Request was successful
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Deleted successfully', Icon(Icons.delete), true));


  //   } else {
  //     // Request failed
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error occured', Icon(Icons.close), false));
  //     throw Exception('Failed to get JSON: ${response.reasonPhrase}');
  //     }
  //   }
}