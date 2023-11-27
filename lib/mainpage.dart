import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/diary.dart';
import 'package:fluttert/navigationDrawer.dart';
import 'package:fluttert/notifications.dart';
import 'package:fluttert/pages/engine.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/homepage.dart';
import 'package:fluttert/pages/profilepage.dart';
import 'package:fluttert/pages/search.dart';
import 'package:fluttert/pages/searchResult.dart';
import 'package:fluttert/providers/HomepageProvider.dart';
import 'package:fluttert/providers/searchProvider.dart';
import 'package:fluttert/trending.dart';
import 'package:fluttert/views/addMain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int currentIndex = 0;
  
  final screens = [

    ChangeNotifierProvider(
      create: (context) => HomepageProvider(),
      child: const HomePage()
      ),
    ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      child: SearchResultPage()
      ),
    
    // TrendingPage(),

    // AddMain(),
    // NotificationsPage(),
    DiaryPage(),
    // ProfilePage(),

  ]; 

  String _usertag = 'username';
  String _photoUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    // _getUserSnippet(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
  }

  // void _getUserSnippet(String user) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/u/snippet/$user/'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     final usertag = data['usertag'] as String;
  //     final photoUrl = data['profile_pic'] as String;
      
  //     setState(() {
  //       _usertag = usertag;
  //       _photoUrl = photoUrl;
  //     });
  //   } else {
  //     throw Exception(response.headers);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // endDrawer: Theme(
        //   data: Theme.of(context).copyWith(
        //     canvasColor: Colors.transparent
        //     ),
        //   child: Drawer(
        //     child: BackdropFilter(
        //       filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
        //       child: NavigationDrawer(),
        //       )
        //   )
        // ),
        //backgroundColor: Color.fromARGB(255, 19, 19, 19),
        
        
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).iconTheme.color,
          //unselectedItemColor: Colors.white38,
          iconSize: 28,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
              ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.local_fire_department_rounded),
            //   label: 'Trending'
            //   ),
            BottomNavigationBarItem(
              // icon: Icon(Icons.add_circle_outline),
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 22,),
              label: 'Engine'
              ),
            
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.notifications),
            //   label: 'Notifications'
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'Diary'
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile'
            // ),
          ],
        ),
      );
  }

}