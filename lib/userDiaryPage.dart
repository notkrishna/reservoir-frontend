

import 'package:flutter/material.dart';
import 'package:fluttert/diary/movieList.dart';
import 'package:fluttert/diary/progressPage.dart';
import 'package:fluttert/diary/reviewPage.dart';
import 'package:fluttert/diary/watchedPage.dart';
import 'package:fluttert/providers/movieListProvider.dart';
import 'package:fluttert/providers/progressProvider.dart';
import 'package:fluttert/providers/reviewProvider.dart';
import 'package:fluttert/providers/watchedProvider.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/trendingList.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class UserDiaryPage extends StatelessWidget {
  final String user;
  const UserDiaryPage({
    super.key,
    required this.user,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10,vertical:10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                    create: (context) => ProgressProvider(),
                    child: ProgressPage(
                      userId: user, 
                    )
                  )
                )
              );
            },              
            child: UserDiaryCard(
                'Progress',
                Icon(Icons.timer)
              ),
            ),
                  SizedBox(height: 10,),
            
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                    create: (context) => WatchedProvider(),
                    child: Watchedpage(
                      userId: user, 
                    )
                  )
                )
              );
            },        
              child: UserDiaryCard(
                'Watched', 
                Icon(Icons.check_outlined)
                )
              ),
                  SizedBox(height: 10,),
            
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                    create: (context) => MovieListProvider(),
                    child: MovieListPage(
                      userId: user, 
                    )
                  )
                )
              );
            },        
              child: UserDiaryCard(
                'Lists', 
                Icon(Icons.playlist_add_check)
                )
              ),
                  SizedBox(height: 10,),
            
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                    create: (context) => ReviewProvider(),
                    child: DiaryReviewPage(
                      userId: user, 
                    )
                  )
                )
              );
            },        
              child: UserDiaryCard(
                'Reviews', 
                Icon(Icons.reviews)
                )
              ),
                  SizedBox(height: 10,),
                  
                  
            // GestureDetector(
            //   child: UserDiaryCard(
            //     'Lists', 
            //     Icon(Icons.playlist_add_check)
            //     )
            //   ),
            //       SizedBox(height: 10,),
            // (child: UserDiaryCard('Timestamps', Icon(Icons.more_time))),
            //       SizedBox(height: 10,),
            // UserDiaryCard('Rating & Reviews', Icon(Icons.reviews)),
            //       SizedBox(height: 10,),
            // UserDiaryCard('Watchlist', Icon(Icons.bookmarks_rounded)),
            
          ],
        ),
      ),
    );
  }

  Widget UserDiaryCard(String heading, Icon icon){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(70, 129, 129, 129),
            Color.fromARGB(28, 122, 122, 122),
          ]
        ),
        // color: Color.fromARGB(57, 117, 117, 117),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          ListTile(
            leading: icon,
            // leading: HeadingWidget(heading: '200', size: 25,),
            title: HeadingWidget(heading: heading, size: 25,),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          // SizedBox(height: 10,),
          // TrendingList(query: 'r'),
        ],
      ),
      // child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Wrap(
      //               alignment: WrapAlignment.spaceBetween,
      //               children: [
      //                 HeadingWidget(heading: heading),
      //                 // Icon(Icons.arrow_forward_ios)
      //               ],
      //             ),
      //             SizedBox(height: 10,),
      //             // TrendingList(query: 'r'),
      //           ],
      //         ),
    );
  }
}
