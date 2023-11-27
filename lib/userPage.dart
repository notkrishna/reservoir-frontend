import 'package:flutter/material.dart';
import 'package:fluttert/diary.dart';
import 'package:fluttert/diary/progressPage.dart';
import 'package:fluttert/diary/reviewPage.dart';
import 'package:fluttert/diary/timestamps.dart';
import 'package:fluttert/diary/watchlist.dart';
import 'package:fluttert/providers/userPagePostsProvider.dart';
import 'package:fluttert/userDiaryPage.dart';
import 'package:fluttert/userPageHeader.dart';
import 'package:fluttert/userPagePosts.dart';
import 'package:provider/provider.dart';


class UserPage extends StatefulWidget {
  final String user;
  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  final double fontSize = 25;
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
  
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 2, 
      vsync: this
    );
    late Color? imageShadow = Theme.of(context).primaryColor;
    
    return Scaffold(
      //backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      //backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              bottom: TabBar(

                controller:_tabController,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Theme.of(context).iconTheme.color,
                labelStyle: TextStyle(
                       fontSize: 40,
                       fontFamily: 'Outfit'
                     ),
                tabs: [
                    itemfunc(Icon(Icons.web_stories),' Posts'),
                    itemfunc(Icon(Icons.book),' Diary'),
                    ],
                  ),
                  expandedHeight: 370,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: SafeArea(
                      child: UserPageHeader(user: widget.user,),
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
              child: UserPostPage(user: widget.user,)
              ),
            UserDiaryPage(user: widget.user,)
          ]
        )
          
      ),
    )
    );
  }
}

