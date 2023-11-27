import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class MovieStatsHead extends StatefulWidget {
  final int rating_count;
  final double avg_rating;
  const MovieStatsHead({super.key, required this.avg_rating, required this.rating_count});

  @override
  State<MovieStatsHead> createState() => _MovieStatsHeadState();
}

class _MovieStatsHeadState extends State<MovieStatsHead> {
  final double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
            padding: EdgeInsets.symmetric(vertical:10,horizontal: 30),
          child: Container(
              padding: EdgeInsets.all(1),
              //color:Color.fromARGB(255, 255, 0, 0),
              width: 400,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Column(
                    // children: [
                    //   Text(
                    //   'Rank',
                    //   style: TextStyle(
                    //     fontFamily: 'Outfit',
                    //     fontSize: 12,
                    //     //color: Color.fromARGB(255, 255, 255, 255),
                        
                    //   ),
                    //   textAlign: TextAlign.justify,
                    //   ),
                    // Text(
                    //   '2000',
                    //   style: TextStyle(
                    //     fontFamily: 'Outfit',
                    //     fontSize: fontSize,
                    //     //color: Color.fromARGB(255, 255, 255, 255),
                    //     fontWeight: FontWeight.bold
                    //   ),
                    //   textAlign: TextAlign.justify,
                    //   ),
                    
                    // ]),
                    // SizedBox(width: 30,),
                  Column(
                    children: [
                    Text(
                      'Ratings',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        //color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.justify,
                      ),
                    Text(
                      '${widget.rating_count}',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: fontSize,
                        //color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.justify,
                      ),
                    
                    ]),
                    SizedBox(width: 30,),
                  Column(
                    children: [
                    Text(
                      'Avg Rating',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        //color: Color.fromARGB(255, 255, 255, 255),
                        
                      ),
                      textAlign: TextAlign.justify,
                      ),
                    Text(
                      '${widget.avg_rating}/5',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: fontSize,
                        //color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                      
                      ),
                    
                    ]),
                  ]
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     padding: const EdgeInsets.symmetric(horizontal: 70),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(100)
                  //       )),
                    
                  //   onPressed: (){
                  //     Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => MoviePage())); 
                  //   }, 
                  //   child: Text(
                  //     'More Stats',
                  //     style: TextStyle(
                  //       fontFamily: 'Outfit',
                  //       color: Colors.white
                  //       ),
                  //     )),
                ],
              ),
            ),
          ),
    );
  }
}