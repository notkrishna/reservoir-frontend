import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/movieTimelineProvider.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/timelineProvider.dart';

class EditDialogueBox extends StatefulWidget {
  final String movie;
  final int stamp;
  final String id;
  final BuildContext cxt;
  final String pway;
  const EditDialogueBox({
    super.key, 
    required this.movie, 
    required this.stamp, 
    required this.id,
    required this.cxt,
    required this.pway,
    });

  @override
  State<EditDialogueBox> createState() => _EditDialogueBoxState();
}

class _EditDialogueBoxState extends State<EditDialogueBox> {
  // late TextEditingController _textController;
  final _stamp = TextEditingController();
  final _stampText = TextEditingController();
  int _oldStamp = 0;

  bool isStampStatusPublic = true;
  double btnsize = 18;

  // @override
  // Future<void> putData(String Value) async{
  //   final response = await http.post(
  //     Uri.parse('${Globals().url}/api/ts/list/'),
      
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    _oldStamp = widget.stamp;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Timestamp'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back_ios)
          ),
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10)
      // ),
      // title: Text('Edit Timestamp'),
      body: 
      SafeArea(
        child: FutureBuilder(
          future: getData(widget.movie, _oldStamp),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Timeline dt = snapshot.data!;
              _stamp.text = dt.stamp.toString();
              _stampText.text = dt.stampText;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
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
                          // onChanged: (value){
                          //     _newStamp = value;
                          // },
                        ),
                        SizedBox(height: 5,),
                        TextField(
                          controller: _stampText,
                          minLines: 5,
                          maxLines: 12,
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
                                    Provider.of<MovieTimelineProvider>(widget.cxt, listen: false).editData(context, _stamp.text, _stampText.text, widget.id, widget.movie, isStampStatusPublic);

                                  } else if (widget.pway == 'diary') {
                                    Provider.of<TimelineProvider>(widget.cxt, listen: false).editData(context, _stamp.text, _stampText.text, widget.id, widget.movie, isStampStatusPublic);

                                  } else if (widget.pway == 'progress') {
                                    Provider.of<ProgressDetailProvider>(widget.cxt, listen: false).editData(context, _stamp.text, _stampText.text, widget.id, widget.movie, isStampStatusPublic);

                                  }
                                  // postData(widget.movie, widget.stamp, _stampText.text);
                                  // _oldStamp = int.parse(_stamp.text);
                                  // Navigator.pop(context);
                                },
                                
                                child: Text('Save'),
                              ),
                            ],
                          )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError){
              return Text('error');
            } else {
              return Loading(x: 0.01, y: 0.5);
            }
          },
        ),
      ),
      
      
     
    );
  }

  // Future<void> postData(int movie, int stamp, String stampText) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.put(
  //     Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
  //   body: json.encode({'stamp':int.parse(_stamp.text), 'stampText':stampText, 'movie':widget.movie, 'isPublic':isStampStatusPublic}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=200){
  //     throw Exception(response.body);
  //   }
  // }
  Future<Timeline> getData(String movie,int stamp) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200) {
      // Request was successful
      final jsonBody = jsonDecode(response.body);
      return Timeline.fromJson(jsonBody);
    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
    }
  }
}