import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/HomepageProvider.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/providers/userPagePostsProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostDialogueEditBox extends StatefulWidget {
  final String id;
  final String movie;
  final BuildContext cxt;
  final String pway;
  // final Function() onEdit;
  const PostDialogueEditBox({
    super.key, 
    required this.id, 
    required this.movie,
    required this.cxt,
    required this.pway,
    });

  @override
  State<PostDialogueEditBox> createState() => _PostDialogueEditBoxState();
}

class _PostDialogueEditBoxState extends State<PostDialogueEditBox> {
  // late TextEditingController _textController;
  final _title = TextEditingController();
  final _caption = TextEditingController();
  bool isStampStatusPublic = true;
  double btnsize = 18;


  // @override
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
        title: Text('Edit Post'),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getData(widget.id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final dt = snapshot.data!;
              _title.text = dt.title;
              _caption.text = dt.caption;
              return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.photo_camera),
                    hintText: 'Post Title',
                    border: OutlineInputBorder(),
                    iconColor: Colors.white,
                    
                  ),
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _caption,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.photo_camera),
                    hintText: 'Post content',
                    border: OutlineInputBorder(),
                    iconColor: Colors.white,
                    
                  ),
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                ),
                // isStampStatusPublic? 
                //   ElevatedButton.icon(
                //     onPressed: (){
                //       setState(() {
                //         isStampStatusPublic = !isStampStatusPublic;
                //       });
                //     }, 
                //     label: Text('Public'),
                //     icon: Icon(Icons.public, size: btnsize,),
                //   ):
                //   ElevatedButton.icon(
                //     onPressed: (){
                //       setState(() {
                //         isStampStatusPublic = !isStampStatusPublic;
                //       });
                //     }, 
                //     label: Text('Private'),
                //     icon: Icon(Icons.lock, size: 15,),
                //   ),

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
                      if(widget.pway=='homepage')
                        {
                          Provider.of<HomepageProvider>(widget.cxt,listen: false).editData(context, _title.text, _caption.text, widget.id, widget.movie);
                        } 
                      else if (widget.pway == 'tribe')
                        {
                          Provider.of<PostProvider>(widget.cxt,listen: false).editData(context, _title.text, _caption.text, widget.id, widget.movie);
                        }  
                      else if (widget.pway == 'userpage')
                      {
                        Provider.of<UserPageProvider>(widget.cxt,listen: false).editData(context, _title.text, _caption.text, widget.id, widget.movie);
                      }                    
                      // editData(_title.text, _caption.text, widget.id);
                    },
                    
                    child: Text('Save'),
                  ),
                ],
              )
            ],
          );
            } else if (snapshot.hasError){
              return Text('error');
            } else {
              return Loading(x: 0.5, y: 0.01);
            }
          },

        ),
      ),
      
    );
  }

  // Future<void> editData(String title, String caption, int id) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.put(Uri.parse('${Globals().url}api/post/$id/'),
  //   body: json.encode({'title':title, 'caption':caption, 'movie':widget.movie}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=200){
  //     throw Exception(response.body);
  //   }
  // }

  Future<Tribe> getData(String id) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(Uri.parse('${Globals().url}api/post/$id/'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200) {
      // Request was successful
      final jsonBody = jsonDecode(response.body);
      return Tribe.fromJson(jsonBody);
    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
  
}