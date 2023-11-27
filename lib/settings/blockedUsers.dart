import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/notificationModel.dart';
import 'package:fluttert/models/userModel.dart';
import 'package:fluttert/moviePostPage.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/tools/commentList.dart';
import 'package:fluttert/tools/loading.dart';

import 'package:http/http.dart' as http;

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final _scrollController = ScrollController();
  int _page = 1;
  String _nextPageUrl = '';
  List<BlockedUser> notifs = [];

  @override
  void initState(){
    super.initState();
    fetchBlockedUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchBlockedUsers();
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
      appBar: AppBar(
        title: Text('Blocked users'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(vertical:15,horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Expanded(
                  child: ListView.builder(
                            controller: _scrollController,
                            itemCount: notifs.length + 1,
                            itemBuilder: (context, index) {
                              
                              if (index<notifs.length){
                                final item = notifs[index];
                                return ListTile(
                                  trailing: TextButton.icon(
                                    icon: Icon(Icons.delete_outline,color: Colors.red,),
                                    label: Text('Unblock', style: TextStyle(color: Colors.red),),
                                    onPressed: (){
                                      removeRequest(item.blockedUser, index);
                                    },
                                  ),
                                  title: Text(item.blockedUsertag,),
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
    Future<void> fetchBlockedUsers() async {
      if (_nextPageUrl=='null'){
        return;
      }
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Globals().url}api/u/block/?page=$_page'),
        headers: {
            HttpHeaders.authorizationHeader: 'Bearer $id_token',
            },
      );
      if (response.statusCode==200){
        final data = json.decode(response.body);
        if(mounted){setState(() {
          notifs.addAll(List<BlockedUser>.from(data['results'].map((commentJson) => BlockedUser.fromJson(commentJson))));
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

  void removeRequest(String blocked, int index) async{
    final String base_url = '${Globals().url}api/u/block_more/${blocked}';
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(
      Uri.parse(base_url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        'Content-Type':'application/json; charset=utf-8',
        }
      );
    if(response.statusCode!=204){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' Error', Icon(Icons.close), false));
      throw Exception(response.body);
    } else {
      setState(() {  
      notifs.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' User unblocked', Icon(Icons.check), true));
      // Navigator.pop(context);
    }
  }

}