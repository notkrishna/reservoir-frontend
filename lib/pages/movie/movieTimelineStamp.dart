import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/commentButton.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/diary/editDialogueBox.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/providers/likeButtonProvider.dart';
import 'package:fluttert/providers/movieTimelineProvider.dart';
import 'package:fluttert/tools/commentPostButton.dart';
import 'package:fluttert/tools/expandableText.dart';
import 'package:fluttert/tools/likeButton.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/movieModel.dart';

class MovieTimelineStamp extends StatefulWidget {
  final bool onDiary;
  final String text;
  final int stamp;
  final String user;
  final String usertag;
  final String movie;
  final String movie_name;
  final String coverImgUrl;
  final String id;
  final int commentCount;
  final Function(String tsId) onDelete;
  final BuildContext cxt;
  final String pway;
  final int likeCount;
  final bool isLiked;

  const MovieTimelineStamp({
    super.key, 
    required this.onDiary, 
    required this.text, 
    required this.stamp, 
    required this.user,
    this.usertag = "",
    required this.movie, 
    this.movie_name = "",
    this.coverImgUrl = "",
    required this.id,
    required this.commentCount,
    required this.onDelete,
    required this.cxt,
    required this.pway,
    required this.likeCount,
    required this.isLiked,
    });

  @override
  State<MovieTimelineStamp> createState() => _MovieTimelineStampState();
}

class _MovieTimelineStampState extends State<MovieTimelineStamp> {
  late Color? imageShadow = Theme.of(context).primaryColor;
  late double mediaWidth = MediaQuery.of(context).size.width;
  TextStyle heading = TextStyle(
    //color: Color.fromARGB(226, 255, 255, 255),
    fontFamily: 'Outfit',
    fontSize: 30,
    
  );
  TextStyle heading2 = TextStyle(
    //color: Color.fromARGB(213, 255, 255, 255),
    fontFamily: 'Outfit',
    fontSize: 16,
    
  );
  TextStyle headingTitle = TextStyle(
      //color: Color.fromARGB(199, 255, 255, 255),
      fontFamily: 'Outfit',
      fontSize: 12,
      fontWeight: FontWeight.bold
    );

  String minuteToHour(double minute){
    int hrs = minute~/60;
    double minutes = minute%60;
    int mins = minutes.toInt();
    return hrs.toString().padLeft(2,"0") + ':' + mins.toString().padLeft(2,"0") + '';
  }

  // String _usertag = 'username';
  // String _photoUrl = '';

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _getUserSnippet(widget.user);
  // }

  // void _getUserSnippet(String user) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/u/snippet/$user/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     final usertag = data['usertag'] as String;
  //     final photoUrl = data['profile_pic'] as String;
      
  //     if(mounted){
  //       setState(() {
  //       _usertag = usertag;
  //       _photoUrl = photoUrl;
  //     });}
  //   } else {
  //     throw Exception(response.headers);
  //   }
  // }
    
  @override
  Widget build(BuildContext context) {
    Color? buttonColor = Theme.of(context).iconTheme.color;
    final themeCond = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: themeCond?Color.fromARGB(255, 18, 18, 18):Color.fromARGB(14, 91, 91, 91),
      
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(120, 114, 114, 114), 
          width: 1
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // widget.onDiary == true
                // ?movieCard(widget.coverImgUrl)
                // :SizedBox.shrink(),
                Container(
                  height: 125,
                  width: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage('https://www.silverpetticoatreview.com/wp-content/uploads/2018/08/arrival-ian.jpg'),
                      fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 0, 0, 0).withOpacity(0.99), 
                      BlendMode.dstATop
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            color: Color.fromARGB(83, 255, 0, 0),
                            child: Text(
                              minuteToHour(widget.stamp.toDouble())+' h',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                              ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                          width: MediaQuery.of(context).size.width/2 - 20,
                          height: 110,
                          // width: mediaWidth/2.75,
                          child: Text(
                          widget.text,
                          style: TextStyle(
                            // fontFamily: 'oswald',
                            fontSize: 15,
                            //color: Color.fromARGB(255, 255, 255, 255),
                            
                          ),
                          textAlign: TextAlign.justify,
                          ),
                        ),

                    widget.onDiary == false ?
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      // height: 60,
                      child: Text(
                        widget.usertag,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                        ),
                      ),
                    ) : 
                    SizedBox.shrink(),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width - 220,
                        //   // width: mediaWidth/2.75,
                        //   child: FutureBuilder(
                        //     future: fetchMovie(widget.movie),
                        //     builder: (context, snapshot) {
                        //       if(snapshot.hasData) {
                        //         Movie dt = snapshot.data!;
                        //         return Text(
                        //         widget.onDiary == true ? dt.movieName : _usertag,
                        //         style: TextStyle(
                        //           // fontFamily: 'oswald',
                        //           fontSize: 11,
                        //           color: Color.fromARGB(255, 153, 153, 153),
                                  
                        //         ),
                        //         textAlign: TextAlign.justify,
                        //           );
                        //         } else if (snapshot.hasError) {
                        //           return Text('error');
                        //         } else {
                        //           return Loading(x: 0.5,y: 0.01,);
                        //         }
                        //     },
                            
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ExpandableText(text: widget.user, limit: 5)
                        //   ),
                    // Row(
                    //   children: [
                    //     ElevatedButton.icon(
                          
                    //       style: ElevatedButton.styleFrom(
                    //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //         elevation: 0,
                    //         primary: Colors.transparent,
                    //         padding: EdgeInsets.all(0),
                    //       ),
                    //       onPressed: (){

                    //         }, 
                    //       icon: Icon(
                    //         Icons.forum,
                    //         size: 16,
                    //         color: buttonColor,
                    //         ), 
                    //       label: Text('2.2K',
                    //       style: TextStyle(
                    //         fontFamily: 'Outfit',
                    //         color: buttonColor
                    //       ),
                    //       )
                    //       ),
                    //       SizedBox(width: 8,),
                    //       LikeButtonWidget()
                    //   ],
                    // )
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      // LikeButton(
                      //   type:'ts', 
                      //   post: widget.id
                      // ),
                      // LikeButton(isLiked: isLiked, likeCount: likeCount, type: 'ts', post: widget.id, cxt: widget.cxt),
                      // ChangeNotifierProvider<LikeButtonProvider>(
                      //           create: (context) => LikeButtonProvider(isLiked: widget.isLiked, likeCount: widget.likeCount),
                      //           child: 
                                LikeButton(
                                  isLiked: widget.isLiked,
                                  likeCount: widget.likeCount,
                                  type: 'ts',
                                  post: widget.id,
                                  cxt: widget.cxt,
                                ),
                              // ),
                      CommentPostButtonWidget(type: 'ts', post: widget.id, commentCount: widget.commentCount,),
                      widget.user != FirebaseAuth.instance.currentUser!.uid ? Text('') 
                          : PopupMenuButton(
                              position: PopupMenuPosition.over,
                              iconSize: 10,
                              // splashRadius: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 1,
                                  ),
                                PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 2,
                                  )
                              ],
                              onSelected: (value) {
                                if (value == 1){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>
                                      EditDialogueBox(
                                      id:widget.id,
                                      movie: widget.movie, 
                                      stamp: widget.stamp,
                                      cxt: widget.cxt,
                                      pway: widget.pway,
                                      )
                                    )
                                  );
                                  
                                  
                                }
                                else if (value==2) {
                                  widget.onDelete(widget.id);
                                }
                              },
                              child: SizedBox(
                                width: 15,
                                height: 15,
                                child: Icon(Icons.more_vert, size: 15,),
                                ),
                            ),
                      
                      
                      // ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.chat_bubble_outline,size: 13,), label: Text('52'),),
                    ],
                    ),
                    
                  ],
                ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: 
                  // ),
                
              ],
            ),
            
            // SizedBox(height: 2,),
          ],
        ),
      ),
    );
  }

  Widget movieCard(String coverImgUrl){
    return Image.network(
      coverImgUrl,
      width: 125,
      height: 175,
      fit: BoxFit.cover,
    );
  }

  // Future<void> DeleteData(int movie, int stamp) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.delete(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Deleted successfully', Icon(Icons.delete), true));
  //   } else {
  //     // Request failed
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error occured', Icon(Icons.close), false));
  //     throw Exception('Failed to get JSON: ${response.reasonPhrase}');
  //     }
  //   }
}