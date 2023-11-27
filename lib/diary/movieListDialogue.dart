import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/movieListProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MovieListDialogueBox extends StatefulWidget {
  final Function(String lname) onCreate;
  const MovieListDialogueBox({
    super.key,
    required this.onCreate,
    });

  @override
  State<MovieListDialogueBox> createState() => _MovieListDialogueBoxState();
}

class _MovieListDialogueBoxState extends State<MovieListDialogueBox> {
  // late TextEditingController _textController;
  final _listName = TextEditingController();
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Text('Create List'),
      content: 
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
              controller: _listName,
              decoration: InputDecoration(
                // prefixIcon: Icon(Icons.photo_camera),
                hintText: 'Name of your list',
                border: OutlineInputBorder(),
                iconColor: Colors.white,
                
              ),
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 5,),
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
            widget.onCreate(_listName.text);
          },
          
          child: Text('Save'),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
  // Future<void> postData(String lname) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.post(Uri.parse('${Globals().url}mls/d/?action=create'),
  //   body: json.encode({'list_name':lname}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=201){
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Error occured', Icon(Icons.close), false));
  //     throw Exception(response.body);
  //   } else {
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' List created', Icon(Icons.list), true));
  //       Navigator.pop(context);
  //   }
  // }
}