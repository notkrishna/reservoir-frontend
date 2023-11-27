import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/providers/reviewProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/ratingWidget.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReviewDialogueBoxEdit extends StatelessWidget {
  final String movie;
  final BuildContext cxt;
  final String pway;
  ReviewDialogueBoxEdit({
    super.key, 
    required this.movie,
    required this.cxt,
    required this.pway
    });

  int _rating = 1;
  TextEditingController _review = TextEditingController();


  void _handleRatingChanged(int rating) {
      _rating = rating;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Review'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ),
        extendBodyBehindAppBar: false,
        body: 
        FutureBuilder(
          future: getData(movie),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
              Rating dt = snapshot.data!;
              _rating = dt.rating;
              _review.text = dt.review;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RatingWidget(
                        size: 28,
                        rating: _rating,
                        onRatingChanged: _handleRatingChanged,
                      ),
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
                            border: OutlineInputBorder(),
                            iconColor: Colors.white,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 15,
                          textAlignVertical: TextAlignVertical.top,
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent
                                ),
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  if (pway == 'movie'){
                                    Provider.of<MovieReviewProvider>(cxt, listen: false).editData(context, _rating, _review.text, movie);
                                  } else if (pway == 'diary'){
                                    Provider.of<ReviewProvider>(cxt, listen: false).editData(context, movie, _rating, _review.text);

                                  }
                                }
                                ,
                                child: Text('Save'),
                              ),
                          ],
                        )
                    ],
                  ),
                ),
              );

            } else if (snapshot.hasError) {
              return Text('error');
            } else {
              return Loading(x: 0.01, y: 0.5);
            }
          }
        ),
      ),
    );







///////////////////////////////////////////
    // return AlertDialog(
    //   title: HeadingWidget(heading: 'Rate & Review'),
    //   contentPadding: EdgeInsets.all(10),
    //   content: 
    //   FutureBuilder(
    //     future: getData(widget.movie),
    //     builder: (context,snapshot) {
    //       if(snapshot.hasData) {
    //         Rating dt = snapshot.data!;
    //         _rating = dt.rating;
    //         _review.text = dt.review;
    //         return Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             RatingWidget(
    //               size: 28,
    //               rating: _rating,
    //               onRatingChanged: _handleRatingChanged,
    //             ),
    //             SizedBox(height: 15,),
    //             // TextField(
    //             //     // controller: _stamp,
    //             //     decoration: InputDecoration(
    //             //       // prefixIcon: Icon(Icons.photo_camera),
    //             //       hintText: 'Review Title',
    //             //       border: OutlineInputBorder(),
    //             //       iconColor: Colors.white,
                      
    //             //     ),
    //             //     keyboardType: TextInputType.multiline,
    //             //   ),
    //             //   SizedBox(height: 5,),
    //               TextField(
    //                 controller: _review,
    //                 decoration: InputDecoration(
    //                   // prefixIcon: Icon(Icons.photo_camera),
    //                   hintText: 'Your Review',
    //                   border: OutlineInputBorder(),
    //                   iconColor: Colors.white,
    //                 ),
    //                 keyboardType: TextInputType.multiline,
    //                 maxLines: 4,
    //                 textAlignVertical: TextAlignVertical.top,
    //               ),
    //           ],
    //         );

    //       } else if (snapshot.hasError) {
    //         return Text('error');
    //       } else {
    //         return Loading(x: 0.01, y: 0.5);
    //       }
    //     }
    //   ),
      
    //   actions: <Widget>[
    //     ElevatedButton(
    //       onPressed: (){
    //         Navigator.of(context).pop();
    //       }, 
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.transparent
    //       ),
    //       child: Text('Cancel'),
    //     ),
    //     ElevatedButton(
    //       onPressed: (){
    //         editData();
    //         Navigator.of(context).pop();
    //       },
    //       child: Text('Save'),
    //     ),
        
    //   ],
    //   backgroundColor: Theme.of(context).colorScheme.secondary,
    // );
  }

  // Future<void> editData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.put(
  //     Uri.parse('${Globals().url}api/rating/${widget.movie}/'),
  //   body: json.encode({"rating":_rating, "review":_review.text}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode==200){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Updated successfully', Icon(Icons.edit), true));
  //     Navigator.of(context).pop();

  //   } else{
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Failed to update review', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   }
  // }

  Future<Rating> getData(String movie) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(Uri.parse('${Globals().url}api/rating/$movie/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200) {
      // Request was successful
      final jsonBody = jsonDecode(response.body);
      return Rating.fromJson(jsonBody);
    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
}