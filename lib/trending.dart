import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/trendingHeader.dart';
import 'package:fluttert/trendingList.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override

  Widget build(BuildContext context) {
    Color? highlightColor = Theme.of(context).scaffoldBackgroundColor;
    final fieldText = TextEditingController();
    void clearText(){
      fieldText.clear();
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical:15,horizontal: 15),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment(0,-1),
          //     end: Alignment(0,-0.8),
          //     colors: [
          //       Color.fromARGB(255, 43, 43, 43),
          //       Colors.black,
          //     ]
          //     ),
          //   //borderRadius: BorderRadius.circular(25),
          // ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //SizedBox(height: 10,),
                
                Container(
                  //padding: EdgeInsets.only(bottom:3),
                  decoration: BoxDecoration(
                    //color: Color.fromARGB(255, 29, 29, 29),
                    gradient: LinearGradient(
                      begin: Alignment(1,0),
                      end: Alignment(0,0),
                      colors: [
                        Color.fromARGB(255, 89, 0, 255),
                        highlightColor,
                      ]
                    ),
                     borderRadius: BorderRadius.circular(100),
                  ),
                  child: 
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department),
                      Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        ),
                      ),
                      // Icon(Icons.keyboard_arrow_down),

                    ],
                  ),
                ),

                SizedBox(height: 12,),

            // TextField(
            //   style: TextStyle(
            //     //color: Colors.white,
            //     fontFamily: 'Outfit',
            //     fontSize: 20,
            //   ),
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     prefixIcon: IconButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }, 
            //       icon: const Icon(Icons.search),
            //       //color: Colors.white,
            //       ),
            //     // suffixIcon: IconButton(
            //     //   onPressed: clearText,
            //     //   icon: const Icon(Icons.cancel),
            //     //   //color: Color.fromARGB(255, 112, 112, 112),
            //     //   ),
            //     filled: true,
            //     //fillColor: Color.fromARGB(255, 25, 25, 25),
            //     hintStyle: TextStyle(
            //       color: Colors.grey, 
            //       fontFamily: 'Outfit', 
            //       fontSize: 25
            //       ),
            //     hintText: 'Search category',
            // ),
            // controller: fieldText,
            
            // ),
            SizedBox(height: 10,),
                TrendingHeader(text: 'TOP MOVIES',),
                TrendingList(query: 'r',),
                SizedBox(height: 10,),
                TrendingHeader(text: 'TOP ANIMATED MOVIES',),
                TrendingList(query: 'animated',),
                SizedBox(height: 10,),
                TrendingHeader(text: 'TOP SCI-FI MOVIES',),
                TrendingList(query: 'science',),
                SizedBox(height: 10,),
                TrendingHeader(text: 'TOP FAMILY MOVIES',),
                TrendingList(query: 'family',),
                SizedBox(height: 10,),
                TrendingHeader(text: 'TOP COMEDY MOVIES',),
                TrendingList(query: 'comedy',),
                SizedBox(height: 10,),

                // IconButton(
                //   onPressed: (){

                //   }, 
                //   icon: Icon(Icons.keyboard_arrow_down),
                // ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}