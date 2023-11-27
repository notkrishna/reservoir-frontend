// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttert/commentCard.dart';
// import 'package:fluttert/models/tribeModel.dart';
// import 'package:fluttert/pages/globals.dart';
// import 'package:fluttert/photoAddBox.dart';
// import 'package:fluttert/postDialogueBox.dart';
// import 'package:fluttert/tools/commentPostCard.dart';
// import 'package:fluttert/tools/expandableText.dart';
// import 'package:fluttert/likeButton.dart';
// import 'package:fluttert/tools/loading.dart';
// import 'package:fluttert/tools/textField.dart';
// import 'package:like_button/like_button.dart';
// import 'package:http/http.dart' as http;

// class AddMain extends StatefulWidget {
//   final int movie;
//   AddMain({super.key, this.movie = 0});
//   @override
//   _AddMainState createState() => _AddMainState();
// }
// class _AddMainState extends State<AddMain> {

//   TextEditingController _controller = TextEditingController();
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {

//     return FloatingActionButton.extended(
//             onPressed: (){
//               showModalBottomSheet(
//                 backgroundColor: Colors.transparent,
//                 isScrollControlled: true,
//                 context: context, 
//                 builder: (context) => buildSheet(context),
//               );
//             },
//             backgroundColor: Color.fromARGB(255, 255, 0, 0),
//             icon: Icon(
//               Icons.add,
//               size: 22,
//               ),
//             label: Text('Add Post',),
//           );
//   }
//   Widget buildSheet(context) => Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Theme.of(context).colorScheme.secondary,

//               ),
//               height: MediaQuery.of(context).size.height*0.3,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // ButtonBar(
//                     //   children: [
//                     //     IconButton(
//                     //       onPressed: (){
//                     //         Navigator.pop(context);
//                     //       }, 
//                     //       icon: Icon(Icons.close),
//                     //     )
//                     //   ],
//                     // ),
//                     // SizedBox(height: 20,),
//                     ButtonBar(
//                       alignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: (){
//                             Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => PostDialogueBox(req: "POST", id: widget.movie, movie: widget.movie)
//                                   ));
//                           }, 
//                           icon: Icon(Icons.edit), 
//                           label: Text('Add Text',style: TextStyle(fontSize: 25),)
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     ButtonBar(
//                       alignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: (){
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PhotoDialogueBox(req: "POST", id: widget.movie, movie: widget.movie)
//                               ));
//                           }, 
//                           icon: Icon(Icons.photo_camera), 
//                           label: Text('Add Photo',style: TextStyle(fontSize: 22),)
//                         ),
//                         // TextButton(onPressed: (){}, child: Text('Coming soon'))
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     ButtonBar(
//                       alignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: (){}, 
//                           icon: Icon(Icons.poll), 
//                           label: Text('Add Poll',style: TextStyle(fontSize: 25),)
//                         ),
//                         // TextButton(onPressed: (){}, child: Text('Coming soon'))
//                       ],
//                     ),
                    
//                   ],
//                 ),
//               ),
//             );

//   // Future<List<PostComment>> fetchComments() async {
//   //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//   //     final response = await http.get(
//   //       Uri.parse('${Globals().url}api/post/comment/list/?post=${widget.post}'),
//   //       headers: {
//   //           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//   //           },
//   //     );
//   //     if (response.statusCode==200){
        
//   //       return (json.decode(response.body) as List)
//   //       .map((data) => PostComment.fromJson(data))
//   //       .toList();
//   //     } else {
//   //       throw Exception(response.body);
//   //     }
//   //   }

//   // Future<void> postData() async {
//   //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//   //   final response = await http.post(Uri.parse('${Globals().url}api/post/comment/create/'),
//   //   body: json.encode({"post":widget.post,"comment":_controller.text}),
//   //   headers: {
//   //       'Content-Type':'application/json; charset=utf-8',
//   //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
//   //     },
//   //   );
//   //   if(response.statusCode!=201){
//   //     throw Exception(response.body);
//   //   }
//   // }
// }