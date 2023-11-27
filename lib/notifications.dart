import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/notificationModel.dart';
import 'package:fluttert/moviePostPage.dart';
import 'package:fluttert/tools/commentList.dart';
import 'package:fluttert/tools/loading.dart';

import 'pages/globals.dart';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _scrollController = ScrollController();
  int _page = 1;
  String _nextPageUrl = '';
  List<NotificationModel> notifs = [];

  @override
  void initState(){
    super.initState();
    fetchNotifs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchNotifs();
      }
    });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color? highlightColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(vertical:15,horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    //padding: EdgeInsets.only(bottom:3),
                    decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 29, 29, 29),
                      gradient: LinearGradient(
                        begin: Alignment(1,0),
                        end: Alignment(0.3,0),
                        colors: [
                          Color.fromARGB(255, 129, 129, 129),
                          highlightColor,
                        ]
                      ),
                       borderRadius: BorderRadius.circular(100),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.notifications),
                        Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                  child: ListView.builder(
                            controller: _scrollController,
                            itemCount: notifs.length + 1,
                            itemBuilder: (context, index) {
                              
                              if (index<notifs.length){
                                final item = notifs[index];
                                return ListTile(
                                leading: CircleAvatar(
                                  child: Text(item.body[0].toUpperCase()),
                                  radius: 20,
                                ),
                                title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                                subtitle: Text(item.body),
                                onTap: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => MoviePostPage(post: item.post_id))
                                  );
                                },
                              );
                            } else {
                              return _nextPageUrl!='null'?Loading():SizedBox(height: 0,);
                            }
                            },
                          )
                      
                ),
              ],
            ),
          
        ),
      ),
    );
  }

 @override
    Future<void> fetchNotifs() async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/u/notifications/?page=$_page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        if(mounted){setState(() {
          notifs.addAll(List<NotificationModel>.from(data['results'].map((commentJson) => NotificationModel.fromJson(commentJson))));
          _page++;
        // _isLoading = false;
          try {
            _nextPageUrl = data['next'] as String? ?? 'null';
          } catch(e) {
            _nextPageUrl = 'null';
          }
      });}
      } else {
        throw Exception(response.body);
      }
      // } else {
      //   return;
      // }
    }

}