import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieTimeline.dart';
import 'package:fluttert/providers/movieTimelineProvider.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:fluttert/providers/progressProvider.dart';
import 'package:fluttert/providers/timelineProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/postProvider.dart';

class DialogueBox extends StatefulWidget {
  final String movie;
  final BuildContext cxt;
  final String pway;
  const DialogueBox({
    super.key, 
    required this.movie,
    required this.cxt,
    required this.pway
    });

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  // late TextEditingController _textController;
  final _stamp = TextEditingController();
  final _stampText = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Timestamp'),
      ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10)
            // ),
            // title: widget.req == 'PUT'? Text('Edit Timestamp'): Text('Create Timestamp'),
            body: 
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      controller: _stamp,
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.photo_camera),
                        hintText: 'Timestamp?',
                        border: OutlineInputBorder(),
                        iconColor: Colors.white,
                        
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(height: 5,),
                    TextField(
                      controller: _stampText,
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.photo_camera),
                        hintText: 'What happens here?',
                        border: OutlineInputBorder(),
                        iconColor: Colors.white,
                        
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                    isStampStatusPublic? 
                      ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            isStampStatusPublic = !isStampStatusPublic;
                          });
                        }, 
                        label: Text('Public'),
                        icon: Icon(Icons.public, size: btnsize,),
                      ):
                      ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            isStampStatusPublic = !isStampStatusPublic;
                          });
                        }, 
                        label: Text('Private'),
                        icon: Icon(Icons.lock, size: 15,),
                      ),
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
                          ElevatedButton(
                            onPressed: (){
                              if (widget.pway == 'movie'){
                                Provider.of<MovieTimelineProvider>(context,listen: false).postData(context, _stamp.text, _stampText.text, widget.movie, isStampStatusPublic);
                              } else if (widget.pway == 'progress') {
                                Provider.of<ProgressDetailProvider>(widget.cxt,listen: false).postData(context, _stamp.text, _stampText.text, widget.movie, isStampStatusPublic);

                              }
                            },
                            child: Text('Save'),
                          ),
                  
                        ],
                      )
                ],
              ),
            ),
         
          );
        
      // ),
    
  }
  // Future<void> postData(String stamp, String stampText) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}api/ts/list/'),
  //   body: json.encode({'stamp':int.parse(stamp), 'stampText':stampText, 'movie':widget.movie, 'isPublic':isStampStatusPublic}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error occured', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   } else {
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Timestamp created', Icon(Icons.timer), true));
  //       Navigator.pop(context);
  //   }
  // }
}