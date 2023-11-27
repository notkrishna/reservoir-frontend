import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttert/commentCard.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/photoAddBox.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/tools/commentPostCard.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:like_button/like_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddPostButton extends StatelessWidget {
  final String movie;
  final BuildContext cxt;
  AddPostButton({
    super.key, 
    required this.movie,
    required this.cxt
    });

  TextEditingController _controller = TextEditingController();
  int count = 0;
  

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton.extended(
      heroTag: 'tribeBtn',
      onPressed: (){
        showModalBottomSheet(
          context: cxt, 
          builder:(context) => buildSheet(context),
          );
      },
      icon: Icon(Icons.add),
      label: Text('Add Post'),
    );
  }
  Widget buildSheet(context) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(cxt).colorScheme.secondary,

              ),
              height: MediaQuery.of(cxt).size.height*0.3,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(cxt).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ButtonBar(
                    //   children: [
                    //     IconButton(
                    //       onPressed: (){
                    //         Navigator.pop(context);
                    //       }, 
                    //       icon: Icon(Icons.close),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(height: 20,),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: (){
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => 
                                    // ChangeNotifierProvider(
                                    //   create: (_) => PostProvider(),
                                    //   child: 
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.95,
                                        child: PostDialogueBox(
                                          req: "POST", 
                                          id: movie, 
                                          movie: movie,
                                          cxt: cxt,
                                          
                                        ),
                                      )
                                      // )
                                  );
                          }, 
                          icon: Icon(Icons.edit), 
                          label: Text('Add Text',style: TextStyle(fontSize: 25),)
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: (){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.95,
                                  child: PhotoDialogueBox(
                                          req: "POST", 
                                          id: movie, 
                                          movie: movie,
                                          cxt: cxt,
                                          // provider: postProvider,
                                          ),
                                );
                              }
                            );
                                  // )
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => 
                            //     // ChangeNotifierProvider<PostProvider>(
                            //     //   create: (_) => PostProvider(),
                            //     //   child: 
                            //       PhotoDialogueBox(
                            //         req: "POST", 
                            //         id: movie, 
                            //         movie: movie,
                            //         cxt: cxt,
                            //         // provider: postProvider,
                            //         )
                            //       // )
                            //   )
                            // );
                          }, 
                          icon: Icon(Icons.photo_camera), 
                          label: Text('Add Photo',style: TextStyle(fontSize: 22),)
                        ),
                        // TextButton(onPressed: (){}, child: Text('Coming soon'))
                      ],
                    ),
                    SizedBox(height: 10,),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: (){}, 
                          icon: Icon(Icons.poll), 
                          label: Text('Add Poll',style: TextStyle(fontSize: 25),)
                        ),
                        // TextButton(onPressed: (){}, child: Text('Coming soon'))
                      ],
                    ),
                    
                  ],
                ),
              ),
            );

  // Future<List<PostComment>> fetchComments() async {
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //       Uri.parse('${Globals().url}api/post/comment/list/?post=${widget.post}'),
  //       headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //           },
  //     );
  //     if (response.statusCode==200){
        
  //       return (json.decode(response.body) as List)
  //       .map((data) => PostComment.fromJson(data))
  //       .toList();
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   }

  // Future<void> postData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}api/post/comment/create/'),
  //   body: json.encode({"post":widget.post,"comment":_controller.text}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //     throw Exception(response.body);
  //   }
  // }
}