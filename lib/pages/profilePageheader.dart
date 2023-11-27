import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/userModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/profileEdit.dart';
import 'package:fluttert/providers/userPagePostsProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:fluttert/api/movieAPI.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/userProfileProvider.dart';
// 


class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}


class _ProfileHeaderState extends State<ProfileHeader> {
  // File? img;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<UserProfileProvider>(context,listen: false);
    provider.fetchUserData();
  }

  @override
  Future<UserProfile> fetchUserData() async {
    try {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse(
        '${Globals().url}api/u/edit/',
        ),
        headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));

    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception('error');
  }

}

  // Future<void> _refreshData() async {
  //   await provider.fetchUserData();
  // }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context,listen: false);

    late Color? imageShadow = Theme.of(context).primaryColor;
    const double fontSize = 18;
    Color? ThemeColor = Theme.of(context).scaffoldBackgroundColor;
    Color? SecondaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      body: 
      SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Consumer<UserProfileProvider>(
          // future: fetchUserData(),
          builder:(context, pvdr, _) {
            // if (snapshot.hasData) {
              final dt = pvdr.userProfile;
              if (pvdr.isLoading){
                return Center(child: Loading(),);
              }

              if (dt.usertag.isEmpty){
                return Center(child: Loading(),);
              }
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                              begin: Alignment.topRight,
                              colors: [Color.fromARGB(134, 71, 71, 71),ThemeColor]
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
                              //       dt.coverPic,
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
                                    GestureDetector(
                                      onTap: () {
                                        // pickImage(ImageSource.gallery);
                                      },
                                      child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage: NetworkImage(
                                                pvdr.profilePic,
                                              ),
                                            ),
                                    ),
                                    Text(
                                        pvdr.usertag,
                                        style: TextStyle(
                                          fontSize: 20
                                          //color: Colors.white
                                        ),
                                      ),
                                    Text(
                                      pvdr.bio,
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
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              //backgroundColor: Color.fromARGB(255, 139, 139, 139),
                              //fixedSize: Size(35, 15)
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => 
                                ProfileEditPage(
                                  cxt: context,
                                  provider: provider,
                                  usertag: pvdr.usertag,
                                  profilePic: pvdr.profilePic,
                                  bio: pvdr.bio,
                                )
                                )
                              );
                            }, 
                            icon: Icon(Icons.edit, size: 16,),
                            label: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
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
            // } else if (snapshot.hasError) {
            //   return Text('${snapshot.error}');
            // }
            // return Transform.scale(
            //   scale: 0.2,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 50,
            //   ),
            // );
          }
        ),
      ),
    );
  }


}