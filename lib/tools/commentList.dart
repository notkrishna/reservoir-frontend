import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentCard.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/moviePostCard.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/commentProvider.dart';
import 'package:fluttert/tools/commentPostCard.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// class CommentList extends StatelessWidget {
//   final String type;
//   final int post;
//   const CommentList({
//     super.key,
//     required this.type,
//     required this.post,
//     });

//   @override
//   Widget build(BuildContext context) {
//     final _scrollController = ScrollController();
//     // final provider = Provider.of<CommentProvider>(context);
//     // final comments = provider.comments;
//     // provider.setComments(type, post);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comments'),
        
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Expanded(
//             child: 
//             Consumer<CommentProvider>(
//               builder: (context,provider,_) {
//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: provider.comments.length+1,
//                   itemBuilder: (context, index) {
//                     if (index<provider.comments.length) {
//                       final comment = provider.comments[index];
//                       // return ListTile(
//                       //   title: Text(comment.comment),
//                       //   trailing: IconButton(
//                       //     icon: Icon(Icons.delete),
//                       //     onPressed: (){
//                       //       setState(() {
//                       //         provider.comments.removeAt(index);
//                       //       });
//                       //     },
//                       //   ),
//                       // );
//                       return CommentPostCardWidget(
//                       id:comment.id, 
//                       user: comment.user, 
//                       comment: comment.comment,
//                       // animation: animation,
//                       onDelete: (int){},
                      
//                     );
//                   } else {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Container() 
//                       // _nextPageUrl!='null'?
//                       //       Loading()
//                       //       :SizedBox(height: 0,),
//                     );
//                   }
//                 },
//           );
//               }
//             ),                      
//         ),

//             Container(
//               padding: EdgeInsets.only(bottom: 15, left: 10, top:10, right:10),
//                 // decoration: BoxDecoration(
//                 //           borderRadius: BorderRadius.circular(25),
//                 //           //color:Color.fromARGB(255, 21, 21, 21),
//                 //           // gradient: LinearGradient(
                            
//                 //           //   colors: [
//                 //           //     Color.fromARGB(255, 21, 21, 21),                          
//                 //           //     Colors.black,
//                 //           //     Color.fromARGB(255, 21, 21, 21),
//                 //           //     Color.fromARGB(255, 21, 21, 21),                          
//                 //           //     ] 
//                 //           //   ),
                        
//                 // ),
//                 child: TextField(
//                   // controller: _controller,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 1,
//                   minLines: 1,
//                   decoration: InputDecoration(
//                     filled: true,
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.send,color: Theme.of(context).iconTheme.color,), 
//                       onPressed: (){},
//                       // provider.addComment(),
//                       // postData,
//                       //color: Color.fromARGB(255, 212, 212, 212),
//                       splashColor: Colors.transparent,
//                       ),
//                     //fillColor: Color.fromARGB(255, 21, 21, 21),
//                     hintText: 'Comment ...',
//                     hintStyle: TextStyle(fontFamily: 'Outfit',color: Color.fromARGB(255, 212, 212, 212)),
                    
//                     border: InputBorder.none
//                   ),
//                 ),
//               )
//           ],
//         )
//         ),
//     );
//   }
// }







// class CommentList extends StatefulWidget {
//   final String type;
//   final int post;
//   CommentList({super.key, required this.type, required this.post});
//   @override
//   _CommentListState createState() => _CommentListState();
// }

// class _CommentListState extends State<CommentList> {
//   final CommentProvider commentProvider = CommentProvider();
//   TextEditingController _controller = TextEditingController();
  
//   int _count = 0;

//   final _scrollController = ScrollController();
//   int _page = 1;
//   List<PostComment> comments = [];
//   // bool _isLoading = true;
//   String _nextPageUrl = '';
  

//   @override
//   void initState(){
//     super.initState();
//     getCommentCount();
//     fetchComments();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//         fetchComments();
//       }
//     });

//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//     Future<void> fetchComments() async {
//       if (_nextPageUrl=='null'){
//         return;
//       }
//       String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//       final response = await http.get(
//         Uri.parse('${Globals().url}api/${widget.type}/comment/list/?post=${widget.post}&page=$_page'),
//         headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $id_token',
//             },
//       );
//       if (response.statusCode==200){
//         final data = json.decode(response.body);
//         if(mounted){setState(() {
//           comments.addAll(List<PostComment>.from(data['results'].map((commentJson) => PostComment.fromJson(commentJson))));
//           _page++;
//         // _isLoading = false;
//           try {
//             _nextPageUrl = data['next'] as String? ?? 'null';
//           } catch(e) {
//             _nextPageUrl = 'null';
//           }
//       });}

//       } else {
//         throw Exception(response.body);
//       }
//     }

//   void getCommentCount() async {
//     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//     final response = await http.get(
//       Uri.parse('${Globals().url}api/${widget.type}/comment/comment_count/?post_id=${widget.post}'),
//       headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//       },
//     );
//     if (response.statusCode == 200){
//       final data = jsonDecode(response.body) as Map<String,dynamic>;
//       final count = data["comment_count"] as int;

//       if(mounted){setState(() {
//         _count = count;
//       });}
//     } else {
//       throw Exception(response.body);
//     }
//   }
  
//   Widget build(BuildContext context) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             ),
//             title: Text(
//                     _count==1?'1 COMMENT':'${_count} COMMENTS',
//                     style: TextStyle(
//                       //color: Color.fromARGB(255, 0, 0, 0),
//                       fontFamily: 'Outfit',
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold
//                     ),
                    
//                   ),
//           ),
//           body: SafeArea(
//             child: Container(
//                   // height: widget.type!='ts'?Mheight*0.8:Mheight*0.9,
//                   color: Theme.of(context).primaryColor,
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: Column(
                      
//                       children: [
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal:15.0),
//                         //   child: MoviePostCard(id: widget.post),
//                         // ),
//                         // SizedBox(height: 20,),
//                         // Container(
//                         //         //color: Color.fromARGB(221, 24, 24, 24),
//                         //         padding: EdgeInsets.only(left: 15),
//                         //         child: Row(
//                         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //           children: [
//                         //             Text(
//                         //                 _count==1?'1 COMMENT':'${_count} COMMENTS',
//                         //                 style: TextStyle(
//                         //                   //color: Color.fromARGB(255, 0, 0, 0),
//                         //                   fontFamily: 'Outfit',
//                         //                   fontSize: 20,
//                         //                   fontWeight: FontWeight.bold
//                         //                 ),
                                        
//                         //                 ),
//                         //               IconButton(
//                         //                 onPressed: (){
//                         //                   Navigator.pop(context);
//                         //                 }, 
//                         //                 icon: Icon(Icons.close)
//                         //                 )
//                         //           ],
//                         //         ),
//                         //       ),
                              
//                         Expanded(
//                             child: 
//                             ListView.builder(
//                               controller: _scrollController,
//                               itemCount: comments.length+1,
//                               itemBuilder: (context, index) {
//                                 if (index<comments.length) {
//                                   final comment = comments[index];
//                                   // return ListTile(
//                                   //   title: Text(comment.comment),
//                                   //   trailing: IconButton(
//                                   //     icon: Icon(Icons.delete),
//                                   //     onPressed: (){
//                                   //       setState(() {
//                                   //         comments.removeAt(index);
//                                   //       });
//                                   //     },
//                                   //   ),
//                                   // );
//                                   return ChangeNotifierProvider(
//                                     create: (context) => CommentProvider(),
//                                     child: CommentPostCardWidget(
//                                     id:comment.id, 
//                                     user: comment.user, 
//                                     comment: comment.comment,
//                                     // animation: animation,
//                                     onDelete: (commentId) {
//                                       if(mounted){
//                                         setState(() {
//                                         // Remove the comment from the comments list
//                                         comments.removeWhere((c) => c.id == commentId);
//                                       }
//                                     );
//                                   }
//                                 }
                                    
//                                 ),
//                                   );
//                               } else {
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 10),
//                                   child: _nextPageUrl!='null'?
//                                         Loading()
//                                         :SizedBox(height: 0,),
//                                 );
//                               }
//                             },
//                           ),                      
//                         ),

//                         Container(
//                           padding: EdgeInsets.only(bottom: 15, left: 10, top:10, right:10),
//                             // decoration: BoxDecoration(
//                             //           borderRadius: BorderRadius.circular(25),
//                             //           //color:Color.fromARGB(255, 21, 21, 21),
//                             //           // gradient: LinearGradient(
                                        
//                             //           //   colors: [
//                             //           //     Color.fromARGB(255, 21, 21, 21),                          
//                             //           //     Colors.black,
//                             //           //     Color.fromARGB(255, 21, 21, 21),
//                             //           //     Color.fromARGB(255, 21, 21, 21),                          
//                             //           //     ] 
//                             //           //   ),
                                    
//                             // ),
//                             child: TextField(
//                               controller: _controller,
//                               keyboardType: TextInputType.multiline,
//                               maxLines: 1,
//                               minLines: 1,
//                               decoration: InputDecoration(
                                
//                                 filled: true,
//                                 suffixIcon: IconButton(
//                                   icon: Icon(Icons.send,color: Theme.of(context).iconTheme.color,), 
//                                   onPressed: postData,
//                                   //color: Color.fromARGB(255, 212, 212, 212),
//                                   splashColor: Colors.transparent,
//                                   ),
//                                 //fillColor: Color.fromARGB(255, 21, 21, 21),
//                                 hintText: 'Comment ...',
//                                 hintStyle: TextStyle(fontFamily: 'Outfit',color: Color.fromARGB(255, 212, 212, 212)),
                                
//                                 border: InputBorder.none
//                               ),
//                             ),
//                           )
//                       ],
//                     ),
//                   ),
//                 ),
//           ),
//         );

//   }

//   Future<void> postData() async {
//     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//     final response = await http.post(Uri.parse('${Globals().url}api/${widget.type}/comment/create/'),
//     body: json.encode({"post":widget.post,"comment":_controller.text}),
//     headers: {
//         'Content-Type':'application/json; charset=utf-8',
//         HttpHeaders.authorizationHeader: 'Bearer $id_token',
//       },
//     );
//     if(response.statusCode!=201){
//       throw Exception(response.body);
//     }
//   }
// }




class CommentList extends StatefulWidget {
  final String type;
  final String post;
  CommentList({super.key, required this.type, required this.post});
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // final CommentProvider commentProvider = CommentProvider();
  TextEditingController _controller = TextEditingController();
  
  // int _count = 0;

  final _scrollController = ScrollController();
  

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final provider = Provider.of<CommentProvider>(context,listen:false);
    provider.fetchComments(widget.type, widget.post);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchComments(widget.type,widget.post);
        }
      }
    );
  }
  
  Widget build(BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Comments',
                    // _count==1?'1 COMMENT':'${_count} COMMENTS',
                    style: TextStyle(
                      //color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    
                  ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<CommentProvider>().refreshComments(widget.type, widget.post);                      
              },
            child: SafeArea(
              child: Container(
                    // height: widget.type!='ts'?Mheight*0.8:Mheight*0.9,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal:15.0),
                          //   child: MoviePostCard(id: widget.post),
                          // ),
                          // SizedBox(height: 20,),
                          // Container(
                          //         //color: Color.fromARGB(221, 24, 24, 24),
                          //         padding: EdgeInsets.only(left: 15),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //                 _count==1?'1 COMMENT':'${_count} COMMENTS',
                          //                 style: TextStyle(
                          //                   //color: Color.fromARGB(255, 0, 0, 0),
                          //                   fontFamily: 'Outfit',
                          //                   fontSize: 20,
                          //                   fontWeight: FontWeight.bold
                          //                 ),
                                          
                          //                 ),
                          //               IconButton(
                          //                 onPressed: (){
                          //                   Navigator.pop(context);
                          //                 }, 
                          //                 icon: Icon(Icons.close)
                          //                 )
                          //           ],
                          //         ),
                          //       ),
                                
                          Expanded(
                              child: 
                              Consumer<CommentProvider>(
                                builder: (context,provider,_) {
                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: provider.comments.length+1,
                                    itemBuilder: (context, index) {
                                      if (index<provider.comments.length) {
                                        final comment = provider.comments[index];
                                        return CommentPostCardWidget(
                                        id:comment.id, 
                                        user: comment.user, 
                                        comment: comment.comment,
                                        usertag: comment.usertag,
                                        profilePic: comment.profilePic,
                                        // animation: animation,
                                        onDelete: (commentId) async {
                                          Provider.of<CommentProvider>(context, listen: false).DeleteData(widget.type,comment.id, context);
                                      }
                                        
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: provider.nextPageUrl!='null'?
                                              Loading()
                                              :SizedBox(height: 0,),
                                      );
                                    }
                                  },
                                );
                              }
                            ),                      
                          ),

                          Container(
                            padding: EdgeInsets.only(bottom: 15, left: 10, top:10, right:10),
                              // decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(25),
                              //           //color:Color.fromARGB(255, 21, 21, 21),
                              //           // gradient: LinearGradient(
                                          
                              //           //   colors: [
                              //           //     Color.fromARGB(255, 21, 21, 21),                          
                              //           //     Colors.black,
                              //           //     Color.fromARGB(255, 21, 21, 21),
                              //           //     Color.fromARGB(255, 21, 21, 21),                          
                              //           //     ] 
                              //           //   ),
                                      
                              // ),
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                                minLines: 1,
                                decoration: InputDecoration(
                                  
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send,color: Theme.of(context).iconTheme.color,), 
                                    onPressed: () async{
                                        // _controller.clear();
                                        Provider.of<CommentProvider>(context,listen: false).postData(widget.type, widget.post, _controller.text);
                                      
                                    },
                                    //color: Color.fromARGB(255, 212, 212, 212),
                                    splashColor: Colors.transparent,
                                    ),
                                  //fillColor: Color.fromARGB(255, 21, 21, 21),
                                  hintText: 'Comment ...',
                                  hintStyle: TextStyle(fontFamily: 'Outfit',color: Color.fromARGB(255, 212, 212, 212)),
                                  
                                  border: InputBorder.none
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        );
  }
  
}















// class CommentList extends StatefulWidget {
//   final String type;
//   final int post;
//   @override
//   _CommentListState createState({Key? key, required this.type, required this.post}) : super(key: key);
// }
// class _CommentListState extends State<CommentList>{
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CommentProvider>(context);
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             title: Text(
//               'Comments',
//               // provider.count == 1 ? '1 COMMENT' : '${provider.count} COMMENTS',
//               style: TextStyle(
//                 fontFamily: 'Outfit',
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           body: SafeArea(
//             child: Container(
//               color: Theme.of(context).primaryColor,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         // controller: provider.scrollController,
//                         itemCount: provider.comments.length + 1,
//                         itemBuilder: (context, index) {
//                           if (index < provider.comments.length) {
//                             final comment = provider.comments[index];
//                             return CommentPostCardWidget(
//                               id: comment.id,
//                               user: comment.user,
//                               comment: comment.comment,
//                               onDelete: (int) {},
//                             );
//                           } else {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(vertical: 10),
//                               child: provider.nextPageUrl != 'null' ? Loading() : SizedBox(height: 0),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(bottom: 15, left: 10, top: 10, right: 10),
//                       child: TextField(
//                         // controller: provider.controller,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: 1,
//                         minLines: 1,
//                         decoration: InputDecoration(
//                           filled: true,
//                           suffixIcon: IconButton(
//                             onPressed: (){},
//                             icon: Icon(Icons.send, color: Theme.of(context).iconTheme.color),
//                             // onPressed: provider.postData,
//                             splashColor: Colors.transparent,
//                           ),
//                           hintText: 'Comment ...',
//                           hintStyle: TextStyle(fontFamily: 'Outfit', color: Color.fromARGB(255, 212, 212, 212)),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
      
//   }
// }
