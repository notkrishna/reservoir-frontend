import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/cards.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/models/ratingModel.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/moviePostCard.dart';
import 'package:fluttert/navigationDrawer.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/pages/searchResult.dart';
import 'package:fluttert/postDialogueBox.dart';
import 'package:fluttert/providers/HomepageProvider.dart';
import 'package:fluttert/tools/addPostButton.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/postProvider.dart';


class HomePage extends StatefulWidget {
  // final int id;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final key = GlobalKey
  final double fontSize = 25;
  
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserSnippet();
    final provider = Provider.of<HomepageProvider>(context,listen:false);
    provider.fetchPosts(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchPosts(context);
      }
    });
  }

  

  // @override
  // Future<void> fetchPosts() async {
  //     try{
  //       if (_nextPageUrl=='null'){
  //       return;
  //       }
  //       String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //       final response = await http.get(
  //         Uri.parse('${Globals().url}api/u/feed/?page=$_page'),
  //         headers: {
  //             HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //             },
  //       );
  //       if (response.statusCode==200){
  //         final data = json.decode(response.body);
  //         if(mounted){
  //           setState(() {
  //           posts.addAll(List<Tribe>.from(data['results'].map((postJson) => Tribe.fromJson(postJson))));
  //           _page++;
  //         // _isLoading = false;
  //           try {
  //             _nextPageUrl = data['next'] as String? ?? 'null';
  //           } catch(e) {
  //             _nextPageUrl = 'null';
  //           }
  //         });}
  //       } else {
  //         throw Exception(response.body);
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Couldn\'t load data', Icon(Icons.close), false));
  //     }
  //     // } else {
  //     //   return;
  //     // }
  //   }

  String _usertag = 'username';
  String _photoUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png';

  void _getUserSnippet() async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    String currUser = await FirebaseAuth.instance.currentUser!.uid;
    final response = await http.get(
      Uri.parse('${Globals().url}api/u/snippet/$currUser/'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final usertag = data['usertag'] as String;
      final photoUrl = data['profile_pic'] as String;
      
      if(mounted){
        setState(() {
        _usertag = usertag;
        _photoUrl = photoUrl;
      });}
    } else {
      throw Exception(response.headers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 40, 
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            "Reservoir",
            style: TextStyle(
              fontFamily: 'Galada',
              // fontFamily: 'Leckrelione',
              fontSize: 25,
              color: Theme.of(context).iconTheme.color
            )
          ),
          // leading: IconButton(
          //     onPressed: (){
          //       Navigator.push(
          //         context, 
          //         MaterialPageRoute(builder: (context) => SearchResultPage()),
          //       );
          //     },
          //     icon: const Icon(Icons.menu), 
          //     iconSize: 25
          //   ),
          actions: <Widget>[
            // IconButton(
            //   onPressed: (){
            //     Navigator.push(
            //       context, 
            //       MaterialPageRoute(builder: (context) => SearchPage()),
            //   );
            // },
            //   icon: const Icon(Icons.search), 
            //   iconSize: 27
            // ),
            // IconButton(
            //   onPressed: (){
            //     Navigator.push(
            //       context, 
            //       MaterialPageRoute(builder: (context) => SearchPage()),
            //   );
            // },
            //   icon: const Icon(Icons.notifications), 
            //   iconSize: 25
            // ),
            // ElevatedButton(
            //   onPressed: (){},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.transparent,
            //   ),
            //   child: Text(
            //     'SIGN IN',
            //     style: TextStyle(
            //       color: Color.fromARGB(255, 0, 255, 234),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18,
            //     ),
            //   )
            // ),


            NavigationDrawer(photoUrl: _photoUrl,),
            
            
            
            // Builder(builder: (context) {
            //   return GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => NavigationDrawer())
            //       );
            //    },
            //     child: CircleAvatar(
            //       radius: 14, 
            //       backgroundImage: Image.network(
            //         _photoUrl
            //         ).image,
                  
            //       )
            //     );
            //   }
            // ),
          ],
        ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<HomepageProvider>().refreshPosts(context);                      
          },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0, vertical:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HeadingWidget(heading: 'Tribe'),
              // SizedBox(height: 10,),
              Expanded(
                child: Consumer<HomepageProvider>(
                  builder: (context, provider, _) {
                    if(provider.posts.isEmpty){
                      return ListView(
                        children: [
                          loadingContainer(),
                          loadingContainer(),
                          loadingContainer(),
                          loadingContainer(),
                          loadingContainer(),

                        ],
                      );
                    } else {
                      return ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.posts.length+1,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                if (index<provider.posts.length){
                                  Tribe item = provider.posts[index];
                                  return MoviePostCard(
                                      id: item.id,
                                      user: item.user,
                                      usertag: item.usertag,
                                      profilePic: item.profilePic,
                                      title: item.title,
                                      caption: item.caption,
                                      photoUrl: item.photoUrl,
                                      postType: item.postType,
                                      movie: item.movie,
                                      postedAt: item.postedAt,
                                      isLiked: item.isLiked,
                                      likeCount: item.likeCount,
                                      commentCount: item.commentCount,
                                      cxt: context,
                                      pway: 'homepage',
                                      onDelete: (postId) async{
                                          Provider.of<HomepageProvider>(context, listen: false).DeleteData(item.id, context);
                                        },
                                      );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: provider.nextPageUrl =='null'?
                                            SizedBox(height: 0,):Loading(),
                                    );
                                  }
                              },
                            );}
                  }
                )
                    
              ),
            ],
          ),
        ),
      )
      
    );
  }

  Widget loadingContainer() {
    bool themeCond= Theme.of(context).scaffoldBackgroundColor==Colors.black;
    Color clr = themeCond?Color.fromARGB(255, 43, 43, 43):Color.fromARGB(255, 232, 232, 232);
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: clr,
              ),
              SizedBox(width: 10,),
              Container(
                width: 50,
                height: 10,
                color: clr,
              )
            ],
          ),
          SizedBox(height: 20,),
          Container(
                height: 100,
                color: clr,
              )
        ],
      ),
    );
  }



  // Future<List<Tribe>> fetchStamps() async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/u/feed/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //         },
  //   );
  //   if (response.statusCode==200){
  //     if (response.body.isEmpty){
  //       throw Exception('Nothing here');
  //     } else {
  //       return (json.decode(response.body) as List)
  //       .map((data) => Tribe.fromJson(data))
  //       .toList();
  //     }
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }
}