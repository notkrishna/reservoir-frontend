import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/diary/editDialogueBox.dart';
import 'package:fluttert/diary/progressCardSlider.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieTimelineStamp.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:fluttert/providers/progressProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/watchedProvider.dart';

class ProgressCard extends StatelessWidget {
  final String id;
  final String movie;
  final String user;
  final int duration;
  final int lastStamp;
  final String coverImgUrl;
  final String movieName;
  final bool isDoneWatching;
  // final bool isUserPage;
  final BuildContext cxt;

  ProgressCard({
    super.key, 
    required this.id,
    required this.movie,
    required this.user,
    required this.duration,
    required this.lastStamp,
    required this.coverImgUrl,
    required this.movieName,
    required this.isDoneWatching,

    // this.isUserPage = false,
    required this.cxt
    });
  // double max = 175;
  // double _value = -1;
  final textController = TextEditingController();
  // List<double> _sliderValues = [];

  // String minuteToHour(double minute){
  //   int hrs = minute~/60;
  //   double minutes = minute%60;
  //   int mins = minutes.toInt();
  //   return hrs.toString().padLeft(2,"0") + ':' + mins.toString().padLeft(2,"0") + '';
  // }

  // String _responseData = '';
  double btnsize = 18;

  String minuteToHour(int min){
      double minute = min.toDouble();
      int hrs = minute~/60;
      double minutes = minute%60;
      int mins = minutes.toInt();
      return hrs.toString().padLeft(2,"0") + ':' + mins.toString().padLeft(2,"0") + '';
    }
  
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchSliderValues();
  // }

  // Future<void> _fetchSliderValues() async {
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //       Uri.parse(
  //         '${Globals().url}api/ts/stampList/?movie=${id}'
  //         ),
  //       headers: {
  //         HttpHeaders.authorizationHeader:'Bearer $id_token',
  //         }
  //       );
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         _sliderValues = data.map((e) => e.toDouble())
  //         .toList().cast<double>();
  //         _value = _sliderValues.last;
  //       });
  //     } else if (response.statusCode == 404) {
  //       setState(() {
  //         _sliderValues = <double>[];
  //       });
  //     }
  //   }

  // Future<Timeline> getStampData(int stamp) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/ts/${id}&$stamp'),
  //     // Uri.parse('${Globals().url}api/ts/${id}&$stamp&$id_token'),
  //     headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //       },
  //     );
  //   try {
  //     if (response.statusCode == 200){
  //       final data = jsonDecode(response.body);
  //       return Timeline.fromJson(data);
  //     } 
  //     // else if (response.statusCode == 404) {
  //     //   return json.encode('message');
  //     // }
  //     else {
  //       throw Exception(response.body);
  //     } }
  //   catch (e) {
  //     throw Exception(response.body);
  //     }
  //   }

  @override
  Widget build(BuildContext context) {
      final themeCond = Theme.of(context).brightness == Brightness.dark;
      final currUser = FirebaseAuth.instance.currentUser!.uid;
      final bool isCurrUser = user==currUser;
      return Card(
            // color: themeCond?Color.fromARGB(255, 18, 18, 18):Color.fromARGB(14, 91, 91, 91),
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     color: Color.fromARGB(120, 114, 114, 114), 
            //     width: 1
            //   ),
            //   borderRadius: BorderRadius.circular(20),
            // ),
            elevation: 0,
            child: SliderTheme(
                    data:SliderThemeData(
                      trackHeight: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MovieCard(
                          id: movie, 
                          height: 50,
                          movieName: movieName,
                          coverImgUrl: coverImgUrl,
                          ),

                        // MovieCard(
                        //   id: id,
                        //   height: 100,
                        // ),
                        // movieCard(coverImg5Url),
                        lastStamp != -1?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(minuteToHour(lastStamp)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.65,
                              child: Slider(
                                // thumbColor: Colors.transparent,
                                value: lastStamp/duration, 
                                onChanged:(value) => null,
                              ),
                            ),
                            Text(minuteToHour(duration)),

                          ],
                        ):
                        SizedBox.shrink(),
                        ButtonBar(
                          children: [
                            isCurrUser == false?
                            const SizedBox.shrink():
                            isDoneWatching == false
                            ?
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 222, 18, 18)
                              ),
                              onPressed: (){
                                Provider.of<ProgressProvider>(cxt,listen: false).doneWatching(context, movie);
                              }, 
                              icon: Icon(Icons.check, size: btnsize,),
                              label: Text('Done'),
                              // label: Text('Finishe'),
                            )
                            :
                            ElevatedButton(
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Colors.red
                              // ),
                              onPressed: (){
                                Provider.of<WatchedProvider>(cxt,listen: false).restartWatching(context, movie, user);
                              }, 
                              child: Wrap(
                                children: [
                                  Icon(Icons.refresh, size: btnsize,),
                                  Text(' Tracking')
                                ],
                              ),
                              // label: Text('Finishe'),
                            ),

                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => 
                                  ChangeNotifierProvider(
                                    create:(context) => ProgressDetailProvider(),
                                    child: ProgressSliderWidget(
                                        id: id,
                                        movie: movie,
                                        pway: 'progress',
                                        userId: user,
                                        // isUserPage: isUserPage,
                                      ),
                                  )
                                  )
                                );
                              }, 
                              // icon: Icon(Icons.timer, size: btnsize,),
                              child: Text('Timeline'),
                            ),
                            
                            // isDoneWatching==false?
                            // ElevatedButton(
                            //   onPressed: (){
                            //     showDialog(
                            //       context: context, 
                            //       builder:(context) => DialogueBox(
                            //         id: id,
                            //         req:'POST',
                            //         movie: movie,
                            //         cxt: context,
                            //         pway: 'progress',
                            //       )
                            //       );
                            //   }, 
                            //   child: Icon(Icons.add,size: btnsize,),
                            //   // label: Text(''),
                            // ):
                            // SizedBox.shrink(),
                            
                                                   
                          ],
                        )
                      ],
                    ),
                  ),
          );
  }

  Widget movieCard(String coverImgUrl){
    return Image.network(
      coverImgUrl,
      width: 200,
      height: 150,
      fit: BoxFit.cover,
    );
  }
  
}










// Slider(
                        //   value: 60,
                        //   onChanged: (value) {
                            
                        //   },

                        // ),
                        
                        // _sliderValues.isEmpty
                        // ? SizedBox(height: 0,)
                        // : ProgressSliderWidget(
                        //   id: id,
                        //   max: max, 
                        //   value: _value, 
                        //   sliderValues: _sliderValues,
                        //   pway: 'progress',
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Text(minuteToHour(_value)),
                        //           Expanded(
                        //             child: Slider(
                        //               activeColor: Color.fromARGB(255, 202, 202, 202),
                        //               inactiveColor: Color.fromARGB(255, 38, 38, 38),
                        //               value: _value,
                        //               label: _value.toString(),
                        //               // divisions: _sliderValues.length-1,
                        //               min: 0,
                        //               max: max,
                        //               // divisions: _sliderValues.length-1,
                        //               onChanged: (value)  {
                        //                 setState(() {
                        //                 _value = _sliderValues.reduce(
                        //                   (a, b) =>
                        //                   (value-a).abs() < (value-b).abs()? a: b 
                        //                   );
                        //               });
                        //               }
                        //             ),
                        //             // child: Slider(
                        //             //   activeColor: Color.fromARGB(255, 202, 202, 202),
                        //             //   inactiveColor: Color.fromARGB(255, 38, 38, 38),
                        //             //   value: _sliderValues,
                        //             //   label: _sliderValues.toString(),
                        //             //   min: 0,
                        //             //   max: max,
                        //             //   // divisions: _sliderValues.length-1,
                        //             //   onChanged: (value) => setState(() {
                        //             //     this._value = value;
                        //             //   }),
                        //             // ),
                        //           ),
                        //           Text(minuteToHour(max)),
                        //         ],
                        //       ),

                          
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       minuteToHour(dt[0].stamp.toDouble()),
                        //       style: TextStyle(
                        //         color: Colors.red,
                        //         backgroundColor: Color.fromARGB(104, 244, 67, 54)
                        //       ),
                        //     ),
                        //     SizedBox(width: 5,),
                        //     // Container(
                        //     //   height: 100,
                        //     //   width: MediaQuery.of(context).size.width*0.3,
                        //     //   color: Colors.white,
                        //     // ),
                        //     Expanded(
                        //       // child: TextField(
                        //       //   controller: textController,
                        //       //   decoration: InputDecoration(
                        //       //     prefixIcon: Icon(Icons.photo_camera),
                        //       //     hintText: 'What happens here?',
                        //       //     border: OutlineInputBorder(),
                        //       //     iconColor: Colors.white,
                                  
                        //       //   ),
                        //       //   keyboardType: TextInputType.multiline,
                        //       // )

                        //       child: Text(
                        //         dt[0].stampText,
                        //       )
                        //     )
                        //   ],
                        // ),
                        // ],
                        //   ),
                        // ),