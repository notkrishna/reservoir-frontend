import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/moviePageImg.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieInfo.dart';
import 'package:fluttert/pages/movie/movieReviews.dart';
import 'package:fluttert/pages/movie/movieTimeline.dart';
import 'package:fluttert/pages/movie/movieTimelineComments.dart';
import 'package:fluttert/pages/movie/movieTribe.dart';
import 'dart:ui' as ui;
import 'package:fluttert/pages/movie/moviesAbout.dart';
import 'package:fluttert/providers/movieReviewsProvider.dart';
import 'package:fluttert/providers/movieTimelineProvider.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:provider/provider.dart';


class MoviePage extends StatefulWidget {
  final String id;
  const MoviePage({super.key, required this.id});
  @override
  State<MoviePage> createState() => _MoviePageState();
}
class _MoviePageState extends State<MoviePage> with TickerProviderStateMixin {
  TextStyle tabBarText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20
    );

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
  
  // Tab itemfunc(Icon icon, String text){
  //   return Tab(
  //   child: Wrap(children: [
  //             icon,
  //             Text(
  //               text,
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold
  //               ),
  //             )
  //           ]
  //         ),
  //       );}
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 3, 
      vsync: this
    );
    return Scaffold(
      //backgroundColor: Colors.black,
    extendBodyBehindAppBar: true,
    //backgroundColor: Color.fromARGB(255, 19, 19, 19),
    body: DefaultTabController(
      length: 3,
      child: NestedScrollView(
        // controller: _scrollController,
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
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Color.fromARGB(255, 255, 17, 0),
                    labelStyle: TextStyle(
                       fontSize: 40,
                       fontFamily: 'Outfit'
                     ),
                    tabs: [
                      // itemfunc(Icon(Icons.feed,), 'Tribe'),
                      // Tab(text: 'Timeline',),
                      // Tab(text: 'Reviews',),
                      // Tab(text: 'Media',),
                      // Tab(text: 'About',),
                      // Tab(text: 'Stats',),
                      // Tab(icon: Icon(Icons.feed),),
                      itemfunc(Icon(Icons.web_stories),''),
                      itemfunc(Icon(Icons.timer),''),
                      itemfunc(Icon(Icons.reviews),''),

                      // itemfunc(Icon(Icons.timer),'Timestamps'),
                      // itemfunc(Icon(Icons.reviews),'Reviews'),
                      // Tab(icon: Icon(Icons.perm_media),),
                      // itemfunc(Icon(Icons.info),''),
                      // Tab(icon: Icon(Icons.insights),),
                    ],
                  ),
                  expandedHeight: Globals().moviePosterHeight+300,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: SafeArea(
                      child: MoviePageAbout(
                        id: widget.id,
                      ),
                    )
                  ),
            )
          ];
        },
        body: 
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create:(context) => PostProvider(),
            ),
            ChangeNotifierProvider(
                create:(context) => MovieTimelineProvider(),
            ),
            ChangeNotifierProvider(
                create:(context) => MovieReviewProvider(),
            ),

          ],
          child: 
          TabBarView(
            controller: _tabController,
            children: [
              // ChangeNotifierProvider(
              //   create:(context) => PostProvider(),
              //   child: 
                MoviePageTribe(
                  id: widget.id,
                  // scrollController:_scrollController,
                ),
              // ),
              // ChangeNotifierProvider(
              //   create: (context) => MovieTimelineProvider(),
              //   child: 
                MovieTimeline(id: widget.id,),
                // ),
              // ChangeNotifierProvider(
              //   create: (context) => MovieReviewProvider(),
              //   child: 
                MoviePageReviews(id: widget.id)
                // ),
              // MoviePageAbout(id: widget.id,),
              // MovieDetail(),
              // Center(child: Text('1'),),
              ]
            ),
        )
      ),
    )
    );
  }
}

