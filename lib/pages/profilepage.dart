import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/diary.dart';
import 'package:fluttert/diary/progressPage.dart';
import 'package:fluttert/diary/reviewPage.dart';
import 'package:fluttert/diary/timestamps.dart';
import 'package:fluttert/diary/watchlist.dart';
import 'package:fluttert/pages/profilePageheader.dart';
import 'package:fluttert/providers/userPagePostsProvider.dart';
import 'package:fluttert/userPagePosts.dart';
import 'package:provider/provider.dart';

import '../providers/userProfileProvider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final double fontSize = 25;
  
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 1, vsync: this);
    late Color? imageShadow = Theme.of(context).primaryColor;
    Tab itemfunc(Icon icon, String text){
    return Tab(
    child: Wrap(children: [
              icon,
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
        );
      }
    return Scaffold(
      //backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      //backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: DefaultTabController(
      length: 1,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Color.fromARGB(255, 255, 255, 255),
                controller: _tabController,
                // isScrollable: true,
                tabs: [
                    itemfunc(Icon(Icons.web_stories),' Posts'),
                    // itemfunc(Icon(Icons.book),' Diary'),
                    ],
                  ),
                expandedHeight: 370,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: ChangeNotifierProvider(
                      create: (_) => UserProfileProvider(),
                      child: ProfileHeader()
                      ),
                  )
                ),
              )
            ];
          },
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            ChangeNotifierProvider(
              create: (context) => UserPageProvider(),
              child: UserPostPage(user: FirebaseAuth.instance.currentUser!.uid,)
              ),
            // DiaryPage(),
          ]
        )
          
      ),
    )
    );
  }
}

