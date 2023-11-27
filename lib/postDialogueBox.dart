import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostDialogueBox extends StatefulWidget {
  final String req;
  final String id;
  final String movie;
  final BuildContext cxt;
  // final Function(String title, String caption) onCreated;

  const PostDialogueBox({
    super.key, 
    required this.req, 
    required this.id, 
    required this.movie,
    required this.cxt
    // required this.onCreated,
    });

  @override
  State<PostDialogueBox> createState() => _PostDialogueBoxState();
}

class _PostDialogueBoxState extends State<PostDialogueBox> {
  // late TextEditingController _textController;
  final _title = TextEditingController();
  final _caption = TextEditingController();
  bool isStampStatusPublic = true;
  double btnsize = 18;


  @override
  // void initState() {
  //   super.initState();
  //   _textController = TextEditingController();
  // }

  // Future<void> putData(String Value) async{
  //   final response = await http.post(
  //     Uri.parse('${Globals().url}/api/ts/list/'),
      
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text('Create Text Post'),
          leading: Icon(Icons.arrow_back_ios),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.photo_camera),
                      hintText: 'Post Title',
                      border: OutlineInputBorder(),
                      iconColor: Colors.white,
                      
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    controller: _caption,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.photo_camera),
                      hintText: 'Post content',
                      border: OutlineInputBorder(),
                      iconColor: Colors.white,
                    ),
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                  ),
                  // isStampStatusPublic? 
                  //   ElevatedButton.icon(
                  //     onPressed: (){
                  //       setState(() {
                  //         isStampStatusPublic = !isStampStatusPublic;
                  //       });
                  //     }, 
                  //     label: Text('Public'),
                  //     icon: Icon(Icons.public, size: btnsize,),
                  //   ):
                  //   ElevatedButton.icon(
                  //     onPressed: (){
                  //       setState(() {
                  //         isStampStatusPublic = !isStampStatusPublic;
                  //       });
                  //     }, 
                  //     label: Text('Private'),
                  //     icon: Icon(Icons.lock, size: 15,),
                  //   ),

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
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                // widget.onCreated(_title.text,_caption.text);
                                Provider.of<PostProvider>(widget.cxt,listen: false).postTextData(context,_title.text,_caption.text,widget.movie);
                                // postData(_title.text, _caption.text);
                                // Navigator.pop(context);
                              },
                              
                              child: Text('Save'),
                            );
                          }
                        ),
                    ],
                  )
              ],
            ),
          ),
        )),
    );
      






    // //////
    // return AlertDialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10)
    //   ),
    //   title: widget.req == 'PUT'? Text('Edit Post'): Text('Add Post'),
    //   content: 
    //   Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       TextField(
    //           controller: _title,
    //           decoration: InputDecoration(
    //             // prefixIcon: Icon(Icons.photo_camera),
    //             hintText: 'Post Title',
    //             border: OutlineInputBorder(),
    //             iconColor: Colors.white,
                
    //           ),
    //           keyboardType: TextInputType.multiline,
    //         ),
    //         SizedBox(height: 5,),
    //         TextField(
    //           controller: _caption,
    //           decoration: InputDecoration(
    //             // prefixIcon: Icon(Icons.photo_camera),
    //             hintText: 'Post content',
    //             border: OutlineInputBorder(),
    //             iconColor: Colors.white,
                
    //           ),
    //           maxLines: 3,
    //           keyboardType: TextInputType.multiline,
    //         ),
    //         // isStampStatusPublic? 
    //         //   ElevatedButton.icon(
    //         //     onPressed: (){
    //         //       setState(() {
    //         //         isStampStatusPublic = !isStampStatusPublic;
    //         //       });
    //         //     }, 
    //         //     label: Text('Public'),
    //         //     icon: Icon(Icons.public, size: btnsize,),
    //         //   ):
    //         //   ElevatedButton.icon(
    //         //     onPressed: (){
    //         //       setState(() {
    //         //         isStampStatusPublic = !isStampStatusPublic;
    //         //       });
    //         //     }, 
    //         //     label: Text('Private'),
    //         //     icon: Icon(Icons.lock, size: 15,),
    //         //   ),
    //     ],
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
    //         postData(_title.text, _caption.text);
    //         Navigator.pop(context);
    //       },
          
    //       child: Text('Save'),
    //     ),
    //   ],
    //   backgroundColor: Theme.of(context).colorScheme.secondary,
    // );
  }

  // Future<void> postData(String title, String caption) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}api/post/create/'),
  //   body: json.encode({'title':title, 'caption':caption, 'movie':widget.movie}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode==201){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context,' Post created successfully', Icon(Icons.edit), true));
  //     int count=0;
  //     Navigator.popUntil(context, (route) {
  //     // Check if there are at least two routes remaining in the stack
  //     count++;
  //     return count==3;
  //   });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context,' Post created successfully', Icon(Icons.edit), true));
  //     throw Exception(response.body);
  //   }
  // }


  
}