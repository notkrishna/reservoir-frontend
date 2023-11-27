import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/reviewCard.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/userReviewCard.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/reviewProvider.dart';

class DiaryReviewPage extends StatefulWidget {
  final String userId;
  const DiaryReviewPage({
    super.key,
    required this.userId,
    });

  @override
  State<DiaryReviewPage> createState() => _DiaryReviewPageState();
}

class _DiaryReviewPageState extends State<DiaryReviewPage> {
  final _scrollController = ScrollController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ReviewProvider>(context,listen:false);
    provider.fetchData(context, widget.userId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchData(context,widget.userId);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser!.uid;
    final bool isCurrUser = widget.userId == currUser;

    return Scaffold(
      appBar: !isCurrUser?
      AppBar(
        title: Text('Reviews'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
      ):
      null,
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0, vertical:5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal:5.0),
            //     child: HeadingWidget(heading: 'Reviews'),
            //   ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:5.0),
                child: Text('Your reviews and ratings will appear here.', style: TextStyle(color: Colors.grey),),
              ),
            SizedBox(height: 10,),
            Expanded(
              child: Consumer<ReviewProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                            itemCount: provider.items.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              Rating item = provider.items[index];
                              return UserReviewCard(
                                id: item.id,
                                movieId:item.movie,
                                movie: item.movie_name,
                                rating: item.rating,
                                review: item.review,
                                userId:widget.userId,
                                coverImgUrl: item.coverImgUrl,
                                commentCount:item.commentCount,
                                likeCount: item.likeCount,
                                isLiked: item.isLiked,
                                cxt: context,
                              );
                            },
                          );
                }
              )
                  
            ),
          ],
        ),
      )
      
    );
  }
  Future<List<Rating>> fetchRatingsAll() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/rating/list/user/'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
          },
    );
    if (response.statusCode==200){
      return (json.decode(response.body) as List)
      .map((data) => Rating.fromJson(data))
      .toList();
    } else {
      throw Exception(response.body);
    }
  }
}