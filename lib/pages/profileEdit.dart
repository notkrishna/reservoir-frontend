import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttert/main.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/userProfileProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfileProvider provider;
  final BuildContext cxt;
  final String usertag;
  final String bio;
  final String profilePic;
  const ProfileEditPage({
    super.key,
    required this.provider,
    required this.cxt,
    required this.usertag,
    required this.bio,
    required this.profilePic
    });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _userTagController = TextEditingController();
  final _bioController = TextEditingController();
  String profilePic = 'https://t4.ftcdn.net/jpg/04/08/24/43/360_F_408244382_Ex6k7k8XYzTbiXLNJgIL8gssebpLLBZQ.jpg';
  File? img;
  Text infoText(String text){
    return Text(
    text, 
    style: TextStyle(
      fontFamily: 'Poppins', 
      fontSize: 12, 
      color: Color.fromARGB(255, 103, 103, 103)
      ),
    );}
  final genderChoices = ['Male','Female','Rather not say'];
  String? genderValue;


  @override
  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img==null) return;

      final imgtmp = File(img.path);
      if(mounted){
        setState(() {
          this.img = imgtmp;

        });
      }
    } on PlatformException catch(e) {
      print('Failed');
    }

  }  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.provider.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    _userTagController.text = widget.usertag;
    _bioController.text = widget.bio;
    profilePic = widget.profilePic;
    UserProfileProvider provider = widget.provider;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile'),
        centerTitle: true,
        actions: <Widget>[
                  IconButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      backgroundColor: Color.fromARGB(255, 255, 0, 102),
                      foregroundColor: Colors.white
                    ),
                    onPressed: (){
                      if (img==null){
                          provider.updateDataWoImg(
                          context,
                          _userTagController.text,
                          _bioController.text
                          );
                      } else {
                        provider.updateData(
                          context,
                          _userTagController.text,
                          _bioController.text,
                          img!.path
                        );
                      }
                      // Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.check)
                  ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: CircleAvatar(
                            radius: 60,
                            backgroundImage: img==null?
                            NetworkImage(
                              profilePic,
                            )
                            :Image.file(
                              img!,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                  ),
                  SizedBox(height: 40,),
                  infoText('USERNAME'),
                  SizedBox(height: 5,),
                  TextField(
                      controller: _userTagController,
                      style: TextStyle(
                        //color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        //fillColor: Color.fromARGB(255, 35, 35, 35),
                        border: InputBorder.none,
                        // suffixIcon: IconButton(
                        //   onPressed: clearText,
                        //   icon: const Icon(Icons.cancel),
                        //   //color: Color.fromARGB(255, 112, 112, 112),
                        //   ),
                        filled: true,
                        //fillColor: Color.fromARGB(255, 25, 25, 25),
                        hintStyle: TextStyle(
                          color: Colors.grey, 
                          fontFamily: 'Outfit', 
                          fontSize: 25
                          ),
                        hintText: 'username',
                    ),
                    ),
                    SizedBox(height: 10,),
                    infoText('BIO'),
                    SizedBox(height: 5,),
                    TextField(
                      minLines: 1,
                      maxLines: 4,
                      controller: _bioController,
                      style: TextStyle(
                        //color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        //fillColor: Color.fromARGB(255, 35, 35, 35),
                        border: InputBorder.none,
                        // suffixIcon: IconButton(
                        //   onPressed: clearText,
                        //   icon: const Icon(Icons.cancel),
                        //   //color: Color.fromARGB(255, 112, 112, 112),
                        //   ),
                        filled: true,
                        //fillColor: Color.fromARGB(255, 25, 25, 25),
                        hintStyle: TextStyle(
                          color: Colors.grey, 
                          fontFamily: 'Outfit', 
                          fontSize: 25
                          ),
                        hintText: 'bio',
                    ),
                    ),
                    SizedBox(height: 10,),
                    // infoText('SOCIAL'),
                    // SizedBox(height: 5,),
                    
                    
                    // SizedBox(height: 10,),
                    // infoText('GENDER'),
                    // SizedBox(height: 5,),
                    // Center(
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 15),
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).colorScheme.secondary,
                    //       // borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: DropdownButton<String>(
                    //       isExpanded: true,
                    //       underline: SizedBox(height: 0),
                    //       style: TextStyle(
                    //       // color: Colors.grey, 
                    //       fontFamily: 'Outfit', 
                    //       fontSize: 20
                    //       ),
                    //       value: genderValue,
                    //       items: genderChoices.map(buildMenuItems)
                    //             .toList(),
                    //       onChanged: (value) {
                    //         if(mounted){
                    //           setState(() {
                    //           this.genderValue = value;                          
                    //         });}
                    //       },
                    //     ),
                    //   ),
                    // )

                    

              ]
            ),
          ),
        ),
      ),
    );
  }
  // DropdownMenuItem<String> buildMenuItems(String gender) =>
  //  DropdownMenuItem(
  //   value: gender,
  //   child: Text(gender)
  //   );


  // Future<void> fetchData() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse(
  //       '${Globals().url}api/u/edit/',
  //       ),
  //       headers: {
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //       },
  //     );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     _userTagController.text = data['usertag'];
  //     _bioController.text = data['bio'];
  //     if(mounted){
  //       setState(() {
  //         profilePic = data['profile_pic'];
  //       });
  //     }

  //   } else {
  //     throw Exception(response.body);
  //   }
  // }

  Future<void> updateDataWoImg(String userTag, String bio) async {
    scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Updating', Icon(Icons.pending), true));

    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.put(Uri.parse('${Globals().url}api/u/edit/'),
    body: json.encode({'usertag':userTag, 'bio':bio}),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if(response.statusCode!=200){
      throw Exception(response.body);
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Updated', Icon(Icons.check), true));

    }
  }

  Future<void> updateData(String userTag, String bio) async {
    scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Updating', const Icon(Icons.pending), true));

    if (img == null) {
      updateDataWoImg(userTag, bio);
    } else {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      String url = '${Globals().url}api/u/edit/';
      // final response = await http.post(Uri.parse('${Globals().url}api/post/create/'),
      // body: json.encode({'title':title, 'caption':caption, 'movie':widget.movie, 'post_type':'photo'}),
      // headers: {
      //     'Content-Type':'application/json; charset=utf-8',
      //     HttpHeaders.authorizationHeader: 'Bearer $id_token',
      //   },
      // );

      // Create a multipart request
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // Set the authorization header
      request.headers['Authorization'] = 'Bearer $id_token';

      // Add the title field
      request.fields['usertag'] = userTag;

      // Add the captions field
      request.fields['bio'] = bio;

      // Add the image file
      

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          img!.path
          )
        );

      // Send the request
      var response = await request.send();

      if(response.statusCode!=200){
        throw Exception(response.stream);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(Globals().flashmsg(' Updated', Icon(Icons.check), true));

      }
    } 
  }
}