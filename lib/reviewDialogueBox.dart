import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReviewDialogueBox extends StatefulWidget {
  final String movie;
  final BuildContext cxt;
  const ReviewDialogueBox({
    super.key, 
    required this.movie,
    required this.cxt,
    });

  @override
  State<ReviewDialogueBox> createState() => _ReviewDialogueBoxState();
}

class _ReviewDialogueBoxState extends State<ReviewDialogueBox> {
  int _rating = 0;
  TextEditingController _review = TextEditingController();

  void _handleRatingChanged(int rating) {
    setState(() {
      _rating = rating;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
          icon: Icon(Icons.close),
        ),
        title: Text('Add Review'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Provider.of<MovieReviewProvider>(widget.cxt,listen: false).postData(context, _rating, _review.text, widget.movie);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RatingWidget(size: 28,onRatingChanged: _handleRatingChanged,),
              SizedBox(height: 15,),
              // TextField(
              //     // controller: _stamp,
              //     decoration: InputDecoration(
              //       // prefixIcon: Icon(Icons.photo_camera),
              //       hintText: 'Review Title',
              //       border: OutlineInputBorder(),
              //       iconColor: Colors.white,
                    
              //     ),
              //     keyboardType: TextInputType.multiline,
              //   ),
              //   SizedBox(height: 5,),
                TextField(
                  controller: _review,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.photo_camera),
                    hintText: 'Your Review',
                    border: InputBorder.none,
                    iconColor: Colors.white,
                    
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 30,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                ),
                
            ],
            
          ),
        ),
      ),
      
    );
  }
  // Future<void> postData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(
  //     Uri.parse('${Globals().url}api/rating/create/${widget.movie}/'),
  //   body: json.encode({'rating':_rating,'review':_review.text}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //           ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error posting review', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Review posted', Icon(Icons.reviews), true));
  //     Navigator.pop(context);
  //   }
  // }
}