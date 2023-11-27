import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentCard.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;

class CommentButtonWidget extends StatefulWidget {
  final String rating;
  CommentButtonWidget({super.key,required this.rating});
  @override
  _CommentButtonWidgetState createState() => _CommentButtonWidgetState();
}
class _CommentButtonWidgetState extends State<CommentButtonWidget> {

  TextEditingController _controller = TextEditingController();
  int _count = 0;

  @override
  void initState(){
    super.initState();
    getCommentCount();
  }
  void getCommentCount() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/rating/comment/comment_count/?rating_id=${widget.rating}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String,dynamic>;
      final count = data["comment_count"] as int;

      if(mounted){
        setState(() {
        _count = count;
      });}
    } else {
      throw Exception(response.body);
    }
  }
  

  @override
  Widget build(BuildContext context) {

    return ElevatedButton.icon(
            onPressed: (){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                builder: (context) => buildSheet(context),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.transparent,
              //shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(25),
              ),
            ),
            
                    icon: IconTheme(
                      data: Theme.of(context).iconTheme,
                      child: Icon(Icons.mode_comment_outlined,
                      size: 15,),
                      //color: Theme.of(context).iconTheme.color,
                      ), 
                    label: Text(
                      '${_count}',
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontFamily: 'Outfit'
                      ),
                    
                    ),
          );
  }
  Widget buildSheet(context) => FutureBuilder(
    future: fetchComments(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final dt = snapshot.data!;
        return Container(
              height: MediaQuery.of(context).size.height*0.8,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    Container(
                            //color: Color.fromARGB(221, 24, 24, 24),
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    _count==1?'1 COMMENT':'${_count} COMMENTS',
                                    style: TextStyle(
                                      //color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                    
                                    ),
                                  IconButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    }, 
                                    icon: Icon(Icons.close)
                                  )
                              ],
                            ),
                          ),

                    Expanded(
                      child: ListView.builder(
                          itemCount: dt.length,
                          itemBuilder: (context, index) {
                            return CommentCardWidget(id:dt[index].id, user: dt[index].user, usertag: dt[index].usertag, comment: dt[index].comment);
                          },
                      ),
                    ),

                    Container(
                        decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //color:Color.fromARGB(255, 21, 21, 21),
                                  // gradient: LinearGradient(
                                    
                                  //   colors: [
                                  //     Color.fromARGB(255, 21, 21, 21),                          
                                  //     Colors.black,
                                  //     Color.fromARGB(255, 21, 21, 21),
                                  //     Color.fromARGB(255, 21, 21, 21),                          
                                  //     ] 
                                  //   ),
                                
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                            Flexible(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.emoji_emotions), 
                                    onPressed: (){},
                                    //color: Color.fromARGB(255, 212, 212, 212),
                                    splashColor: Colors.transparent,
                                    ),
                                  //fillColor: Color.fromARGB(255, 21, 21, 21),
                                  hintText: 'Comment ...',
                                  hintStyle: TextStyle(fontFamily: 'Outfit',color: Color.fromARGB(255, 212, 212, 212)),
                                  
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: postData,
                              icon: Icon(Icons.send),
                              //color: Color.fromARGB(255, 207, 207, 207),
                              iconSize: 25,
                              splashColor: Colors.transparent,

                            )
                          ],
                        ),
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
    },
    
  );

  Future<List<RatingComment>> fetchComments() async {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/rating/comment/list/?rating=${widget.rating}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        
        return (json.decode(response.body) as List)
        .map((data) => RatingComment.fromJson(data))
        .toList();
      } else {
        throw Exception(response.body);
      }
    }

  Future<void> postData() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.post(Uri.parse('${Globals().url}api/rating/comment/create/'),
    body: json.encode({"rating":widget.rating,"comment":_controller.text}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=201){
      throw Exception(response.body);
    }
  }
}