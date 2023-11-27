import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/diary/log.dart';
import 'package:fluttert/diary/movieList.dart';
import 'package:fluttert/diary/progressPage.dart';
import 'package:fluttert/diary/reviewPage.dart';
import 'package:fluttert/diary/timestamps.dart';
import 'package:fluttert/diary/watchedPage.dart';
import 'package:fluttert/diary/watchlist.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/providers/movieListProvider.dart';
import 'package:fluttert/providers/progressProvider.dart';
import 'package:fluttert/providers/reviewProvider.dart';
import 'package:fluttert/providers/timelineProvider.dart';
import 'package:fluttert/providers/watchedProvider.dart';
import 'package:provider/provider.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  Tab itemfunc(Icon icon, String text){
    return Tab(
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
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
    ),
        );
      }
  @override
  Widget build(BuildContext context) {
    Color? highlightColor = Theme.of(context).scaffoldBackgroundColor;
    Color? iconColor = Theme.of(context).iconTheme.color;
    final curr_user = FirebaseAuth.instance.currentUser!.uid;
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorColor: iconColor,
            // labelColor: Theme.of(context).scaffoldBackgroundColor,
            unselectedLabelColor: Colors.grey,
            // indicator: BoxDecoration(
            //   color: iconColor,
            //   borderRadius: BorderRadius.circular(15)
            // ),
            isScrollable: true,
            tabs: [
              // itemfunc(Icon(Icons.lock_clock), ' Progress'),
              // itemfunc(Icon(Icons.view_list),' Lists',),
              // itemfunc(Icon(Icons.timer),' Timestamps',),
              // itemfunc(Icon(Icons.reviews),' Rating & Reviews',),
              // itemfunc(Icon(Icons.bookmark),' Watchlist',),
              // itemfunc(Icon(Icons.alarm),' Upcoming',),

              Tab(text: 'Progress',),
              Tab(text: 'Watched',),
              Tab(text: 'Lists',),
              Tab(text: 'Timestamps',),
              Tab(text: 'Rating & Reviews',),
              Tab(text: 'Watchlist',),
              // Tab(text: 'Upcoming',),
              // // Tab(text: 'Reviews',),
              Tab(text: 'Log',),
            ],
          ),
        ),
        body: TabBarView(
          //physics: NeverScrollableScrollPhysics(),
          children: [
            ChangeNotifierProvider(
              create: (context) => ProgressProvider(),
              child: ProgressPage(userId:curr_user),
              ),
            
            ChangeNotifierProvider(
              create: (context) => WatchedProvider(),
              child: Watchedpage(userId: curr_user,)
              ),
            ChangeNotifierProvider(
              create: (context) => MovieListProvider(),
              child: MovieListPage(userId: curr_user,)
              ),
            ChangeNotifierProvider(
              create: (context) => TimelineProvider(),
              child: TimestampPage()
              ),
            ChangeNotifierProvider(
              create: (context) => ReviewProvider(),
              child: DiaryReviewPage(userId: curr_user,)
            ),
            WatchlistPage(),
            // Center(child: Text('diary'),),
            Log(),
            // Center(child: Text('diary'),),

          ],
        )
      ),
    );
  }
}