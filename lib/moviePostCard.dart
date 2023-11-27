import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/commentButton.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/profilepage.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/postDialogueEdit.dart';
import 'package:fluttert/providers/HomepageProvider.dart';
import 'package:fluttert/providers/likeButtonProvider.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/tools/commentPostButton.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/tools/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/userPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MoviePostCard extends StatelessWidget {
  final String id;
  final Function(String) onDelete;
  // final Function(int) onEdit;
  // final VoidCallback onDelete;
  final String user;
  final String profilePic;
  final String usertag;
  final String title;
  final String caption;
  final String postedAt;
  final String photoUrl;
  final String postType;
  final String movie;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final BuildContext cxt;
  final String pway;

  const MoviePostCard({
    super.key, 
    required this.id,
    required this.onDelete,
    // this.onDelete = void() {
      
    // },
    required this.user,
    required this.profilePic,
    required this.usertag,
    required this.title,
    required this.caption,
    required this.postedAt,
    required this.photoUrl,
    required this.postType,
    required this.movie,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.cxt,
    required this.pway,
  });

//   @override
//   State<MoviePostCard> createState() => _MoviePostCardState();
// }


// class _MoviePostCardState extends State<MoviePostCard> {
  // bool isMe = false;
  // String _usertag = 'username';
  // String _profilePic = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png';

  // String _user = '';
  // String _post_title = '';
  // String _post_content = '';
  // String _time_posted = '';
  // String _photoUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png';
  // String _postType = '';
  // int _movie = 0;

  
  // @override
  // Future<Tribe> _getPostSnippet(int post) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/post/${id}/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = Tribe.fromJson(jsonDecode(response.body));
  //     return data;
  //   } else {
  //     throw Exception(response.headers);
  //   }
  // }

  
  @override
  Widget build(BuildContext context) { 
    bool themeCond= Theme.of(context).scaffoldBackgroundColor==Colors.black;
    // _getUserSnippet(_user);
    // String phUrl = _profilePic;
    //width: MediaQuery.of(context).size.width*0.6,
            return Card(
                color: themeCond?Color.fromARGB(255, 18, 18, 18):Color.fromARGB(14, 91, 91, 91),
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //   color: Color.fromARGB(120, 114, 114, 114), 
                  //   width: 1
                  // ),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              // //color: Color.fromARGB(255, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: 
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // decoration: BoxDecoration(
                          //   // color: Colors.black,
                          //   borderRadius: BorderRadius.all(Radius.circular(100)),
                          //   image: DecorationImage(
                          //     colorFilter: ColorFilter.mode(
                          //       Color.fromARGB(255, 0, 0, 0).withOpacity(0), 
                          //       BlendMode.dstATop
                          //       ),
                          //     image: NetworkImage('https://images.unsplash.com/photo-1589497836818-9ad2fa1df1a0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXwxMzYwOTV8fGVufDB8fHx8fA%3D%3D&w=1000&q=80'),
                          //     fit: BoxFit.cover,
                          //   )
                          // ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          CircleAvatar(
                              radius: 15, 
                              backgroundImage: Image.network(
                                profilePic,
                                ).image,
                              ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => 
                                    FirebaseAuth.instance.currentUser!.uid == user
                                    ? ProfilePage()
                                    : UserPage(
                                        user: user,
                                    )
                                  )
                                );
                              },
                              child: Text(usertag, style: TextStyle(fontFamily: 'Lexend', fontSize: 12),)
                              ),
                              // Text(
                              //   _usertag, 
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     //color: Colors.white,
                              //     // fontWeight: FontWeight.bold, 
                              //     fontFamily: 'Outfit'
                              //   ),
                              // ),

                              ],
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 10,),

                      Text(
                        title, 
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:10.0),
                        child: ExpandableText(
                          limit: 300,
                          text: caption,
                          textColor: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 5,),

                      postType != 'photo'
                      ? const SizedBox(height: 0,)
                      // :Image.network(
                      //   _photoUrl
                      // ),
                      : Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        height: 300, 
                        width: MediaQuery.of(context).size.width-20,
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress == null) return child;
                          return Container(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error loading');
                        },
                      ),
                      // Text(_photoUrl + ' Text'),
                      SizedBox(height: 5,),
                      
                      Text(
                        postedAt,
                        style: TextStyle(
                          //color: Color.fromARGB(255, 152, 152, 152), 
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: Colors.grey
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            buttonPadding: EdgeInsets.zero,
                            children: [
                              // ElevatedButton.icon(
                              //   onPressed: (){

                              //   }, 
                              //   icon: Icon(Icons.favorite), 
                              //   label: 
                              // ),
                              // ChangeNotifierProvider(
                              //   create: (context) => LikeButtonProvider(isLiked: isLiked, likeCount: likeCount),
                              //   child: 
                                LikeButton(
                                  isLiked: isLiked,
                                  likeCount: likeCount,
                                  type: 'post',
                                  post: id,
                                  cxt: cxt,
                                ),
                              // ),
                              CommentPostButtonWidget(
                                type: 'post',
                                post: id,
                                commentCount: commentCount,
                              ),
                              IconButton(
                                onPressed: () async{
                                  final pUrl = 'reservoir://p/';
                                  await Share.share(
                                  pUrl
                                  );
                                }, 
                                icon: Icon(Icons.share), iconSize: 16,),
                              // CommentButtonWidget(),
                              user != FirebaseAuth.instance.currentUser!.uid
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
                                  PopupMenuItem(
                                    child: Text('Edit'),
                                    value: 1,
                                    ),
                                  PopupMenuItem(
                                    child: Text('Delete'),
                                    value: 2,
                                    ),
                                  // PopupMenuItem(
                                  //   child: Text('test'),
                                  //   value: 3,
                                  //   )
                                ],
                                onSelected: (value) {
                                  if (value==1){
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder:(context) => 
                                          PostDialogueEditBox(
                                              id: id, 
                                              movie: movie,
                                              cxt: cxt,
                                              pway: pway,
                                            ),
                                      
                                      )
                                    
                                    );
                                  }
                                  else if (value ==2) {
                                    // DeleteData(id);
                                    onDelete(id);
                                  }
                          //         else if (value ==3) {
                          // // Find the ScaffoldMessenger in the widget tree
                          // // and use it to show a SnackBar.
                          //           ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context,' Failed to delete post', Icon(Icons.close), false));  
                          //         };
                                },
                                
                              )
                            ],
                          ),
                        ],
                      )
                      ],
                      )
                    
              )
            );

  }

  
  
  // Future<void> DeleteData(int id) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(Uri.parse('${Globals().url}api/post/$id/'),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     ScaffoldMessenger.of(context).showSnackBar(flashmsg('Post deleted successfully', Icon(Icons.delete), true));  
  //     // onDelete();
  //   } else {
  //     // Request failed
  //     ScaffoldMessenger.of(context).showSnackBar(flashmsg('Failed to delete post', Icon(Icons.close), false));  

  //     throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      
  //     }
  //   }
}