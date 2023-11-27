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
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:fluttert/tools/textField.dart';
import 'package:like_button/like_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/movieTimelineProvider.dart';

class AddTimestampButton extends StatefulWidget {
  final String movie;
  final BuildContext cxt;
  AddTimestampButton({
    super.key, 
    required this.movie,
    required this.cxt
    });
  @override
  _AddTimestampButtonState createState() => _AddTimestampButtonState();
}
class _AddTimestampButtonState extends State<AddTimestampButton> {
  @override
  Widget build(BuildContext context) {

    return FloatingActionButton.extended(
      heroTag: 'tsBtn',
      onPressed: (){
        showDialog(
          context: context, 
          builder:(context) => buildSheet(context),
          );
      },
      icon: Icon(Icons.more_time),
      label: Text('Add Timestamp'),
    );
  }
  Widget buildSheet(context) {
    final _stamp = TextEditingController();
    final _stampText = TextEditingController();
    bool isStampStatusPublic = true;
    double btnsize = 18;
    Color? clr = Theme.of(context).iconTheme.color;
    return AlertDialog(
      title: Text('Create Timestamp',),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: clr!, width: 2.0)
            ),
            // title: widget.req == 'PUT'? Text('Edit Timestamp'): Text('Create Timestamp'),
            content: 
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: _stamp,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.photo_camera),
                      hintText: 'Timestamp?',
                      border: OutlineInputBorder(),
                      iconColor: clr,
                      
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
                      iconColor: clr,
                      
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
                    )
                    :
                    ElevatedButton.icon(
                      onPressed: (){
                        setState(() {
                          isStampStatusPublic = !isStampStatusPublic;
                        });
                      }, 
                      label: Text('Private'),
                      icon: Icon(Icons.lock, size: 15,),
                    ),
                
              ],
            ),
            
            actions: <Widget>[
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
                  Provider.of<MovieTimelineProvider>(widget.cxt,listen: false).postData(context, _stamp.text, _stampText.text, widget.movie, isStampStatusPublic);
                },
                child: Text('Save'),
              ),
                
            ],
            backgroundColor: Theme.of(context).colorScheme.secondary,
          );
  }

 }