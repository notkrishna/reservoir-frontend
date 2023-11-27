import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/userModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/profileEdit.dart';
import 'package:http/http.dart' as http;
import 'package:fluttert/api/movieAPI.dart';


class UserPageHeader extends StatefulWidget {
  final String user;
  const UserPageHeader({super.key, required this.user});

  @override
  State<UserPageHeader> createState() => _UserPageHeaderState();
}

class _UserPageHeaderState extends State<UserPageHeader> {

  bool _isFollowingVar = false;
  bool _isBlocked = false;
  @override
  void initState() {
    super.initState();
    _checkIfFollowingUser();
    _checkIfUserBlocked();
  }

  void _checkIfFollowingUser() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/u/isfollowing/${widget.user}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data.length==0){
        _isFollowingVar = false;
      } else {
        setState(() {
          _isFollowingVar = true;
        });
      }
    } else {
      _isFollowingVar = false;
    }
  }

  void _toggleFollowUser() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

    setState(() {
      _isFollowingVar = !_isFollowingVar;
    });
    
    if (_isFollowingVar) {
      response = await http.post(
        Uri.parse('${Globals().url}api/u/follow/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'following':widget.user,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}api/u/isfollowing/${widget.user}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    }

    if (response.statusCode != (_isFollowingVar ? 201 : 204)) {
      setState(() {
        _isFollowingVar = !_isFollowingVar;
      });
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
    } else if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Following user', Icon(Icons.check), true));
    } else if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Unfollowed user', Icon(Icons.check), true));
    }
  }

  void _checkIfUserBlocked() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}api/u/block_more/${widget.user}'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data.length==0){
        _isBlocked = false;
      } else {
        setState(() {
          _isBlocked = true;
        });
      }
    } else {
      _isBlocked = false;
    }
  }

  void _toggleBlockUser() async {
    http.Response response;
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();

    setState(() {
      _isBlocked = !_isBlocked;
    });
    
    if (_isBlocked) {
      response = await http.post(
        Uri.parse('${Globals().url}api/u/block/'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            'Content-Type':'application/json',
        },
        body:jsonEncode(
          {
            'blocked':widget.user,
          }
        )
      );
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      response = await http.delete(
        Uri.parse('${Globals().url}api/u/block_more/${widget.user}'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    }

    if (response.statusCode != (_isBlocked ? 201 : 204)) {
      setState(() {
        _isBlocked = !_isBlocked;
      });
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));

    } else if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' User blocked', Icon(Icons.check), true));
    } else if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' User unblocked', Icon(Icons.check), true));
    }  }

  
  @override
  Widget build(BuildContext context) {
    late Color? imageShadow = Theme.of(context).primaryColor;
    const double fontSize = 18;
    Color? ThemeColor = Theme.of(context).scaffoldBackgroundColor;
    Color? SecondaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: FutureBuilder(
          future: fetchUserDataById(widget.user),
          builder:(context, snapshot) {
            if (snapshot.hasData) {
              final dt = snapshot.data!;
              if (snapshot.data!.usertag.isEmpty){
                return Center(child: Text('Oops! Ran into an error!'),);
              }
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                                begin: Alignment.topRight,
                                colors: [SecondaryColor,ThemeColor]
                              ),
                  ),
                child: Column(
                        children: [
                          Stack(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 190,
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: NetworkImage(
                              //       //'https://wallpaperaccess.com/full/51363.jpg'
                              //       //'https://www.popsci.com/uploads/2020/06/05/3NIEQB3SFVCMNHH6MHZ42FO6PA.jpg?auto=webp'
                              //       //'https://wallpaperaccess.com/full/2726422.jpg'
                              //       dt.coverPic
                              //       ),
                              //     fit: BoxFit.fill
                              //   ),
                              // borderRadius: BorderRadius.vertical(
                              //   top: Radius.circular(25),
                              // )
                              // ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width-250, 
                                vertical: 0
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: imageShadow,
                                    spreadRadius: 95,
                                    blurRadius: 50,
                                    offset: Offset(0, 240),
                                  ),
                                ],
                              borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top:15),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                            dt.profilePic
                                            ),
                                          ),
                                    Text(
                                        dt.usertag,
                                        style: TextStyle(
                                          fontSize: 20
                                          //color: Colors.white
                                        ),
                                      ),
                                    Text(
                                      dt.bio,
                                      style: TextStyle(
                                        fontSize: 12
                                        //color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    SizedBox(height: 10,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                            children: [
                              Text(
                              'Followers',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                //color: Color.fromARGB(255, 216, 216, 216),
                                
                              ),
                              textAlign: TextAlign.justify,
                              ),
                            Text(
                              '${dt.followerCount}',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: fontSize,
                                //color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.justify,
                              ),
                            ]),
                            SizedBox(width: 30,),
                          Column(
                            children: [
                            Text(
                              'Ratings',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                //color: Color.fromARGB(255, 216, 216, 216),
                                
                              ),
                              textAlign: TextAlign.justify,
                              ),
                            Text(
                              '${dt.ratingCount}',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: fontSize,
                                //color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.justify,
                              ),
                            ]),
                          SizedBox(width: 30,),
                          Column(
                            children: [
                            Text(
                              'Avg Rating',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                //color: Color.fromARGB(255, 216, 216, 216),
                                
                              ),
                              textAlign: TextAlign.justify,
                              ),
                            Text(
                              '${dt.avgRating}/5',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: fontSize,
                                //color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ),
                            ]),
                          ]
                        ),
                      SizedBox(height: 10,),
                      Center(
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     //backgroundColor: Color.fromARGB(255, 139, 139, 139),
                          //     //fixedSize: Size(35, 15)
                          //   ),
                          //   onPressed: (){}, 
                          //   child: Text(
                          //     'Follow',
                          //     style: TextStyle(
                          //       color: Theme.of(context).iconTheme.color,
                          //     ),
                          //     )
                          //   ),
                            _isFollowingVar == false 
                            ?
                            ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Color.fromARGB(255, 190, 15, 15),
                              //fixedSize: Size(35, 15)
                            ),
                            onPressed: _toggleFollowUser, 
                            child: Text(
                              'Follow',
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                              ),
                              )
                            )
                            :
                            ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //backgroundColor: Color.fromARGB(255, 139, 139, 139),
                              //fixedSize: Size(35, 15)
                            ),
                            onPressed: _toggleFollowUser, 
                              child: Text(
                                'Unfollow',
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                )
                            ),

                             _isBlocked == false 
                            ?
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                //backgroundColor: Color.fromARGB(255, 139, 139, 139),
                                //fixedSize: Size(35, 15)
                              ),
                              onPressed: _toggleBlockUser, 
                              icon: Icon(Icons.block, size: 16,color: Colors.pink,),
                              label: Text(
                                'Block',
                                style: TextStyle(
                                  color: Colors.pink,
                                ),
                              )
                            )
                            :
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  //backgroundColor: Color.fromARGB(255, 139, 139, 139),
                                  //fixedSize: Size(35, 15)
                                ),
                                onPressed: _toggleBlockUser, 
                                icon: Icon(Icons.block, size: 16,color: Colors.pink,),
                                label: Text(
                                  'Unblock',
                                  style: TextStyle(
                                    // color: Colors.pink,
                                  ),
                                )
                              ),
                            
                        // ElevatedButton(
                        //     onPressed: (){}, 
                        //     child: Icon(Icons.person_add,),
                        //     ),
                        // ElevatedButton(
                        //   onPressed: (){}, 
                        //   child: Icon(Icons.chat_bubble)
                        //   ),
                        // ElevatedButton(
                        //   onPressed: (){}, 
                        //   child: Icon(Icons.mail)
                        //   ),
                        ],
                      ),
                    ),
                          ],
          ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Transform.scale(
              scale: 0.2,
              child: CircularProgressIndicator(
                strokeWidth: 50,
              ),
            );
          }
        ),
      ),
    );
  }


}