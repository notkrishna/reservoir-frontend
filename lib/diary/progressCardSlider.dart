import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/diary/editDialogueBox.dart';
import 'package:fluttert/diary/progressDetail.dart';
import 'package:fluttert/models/TimelineModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:fluttert/tools/addProgressStamp.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProgressSliderWidget extends StatefulWidget {
  final String id;
  final String movie;
  final String pway;
  final String userId;
  // final bool isUserPage;
  const ProgressSliderWidget({
    super.key, 
    required this.id, 
    required this.movie, 
    required this.pway,
    required this.userId,
    // this.isUserPage = false,
    });

  @override
  State<ProgressSliderWidget> createState() => _ProgressSliderWidgetState();
}

class _ProgressSliderWidgetState extends State<ProgressSliderWidget> {
  // double max = 175;
  // double _value = -1;
  final textController = TextEditingController();
  // List<double> _sliderValues = [];
  final _scrollController = ScrollController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ProgressDetailProvider>(context,listen:false);
    provider.fetchData(context, widget.movie, widget.userId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchData(context, widget.movie, widget.userId);
      }
    });
  }

  // @override
  // void initState(){
  //   super.initState();
  //   _value = widget.value;
  // }



  // String _responseData = '';
  double btnsize = 18;

  // Future<Timeline> getStampData(int stamp) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.get(
  //     Uri.parse('${Globals().url}api/ts/${widget.id}&$stamp'),
  //     // Uri.parse('${Globals().url}api/ts/${widget.id}&$stamp&$id_token'),
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
      // double _value = widget.value;
      final currUser = FirebaseAuth.instance.currentUser!.uid;
      final bool isCurrUser = widget.userId==currUser;
      return Scaffold(
            //  backgroundColor: Color.fromARGB(255, 28, 28, 28),
            appBar: AppBar(
              elevation: 0,
              title: Text('Timeline'),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            floatingActionButton: isCurrUser?AddProgressStamp(
              id: widget.id,
              movie: widget.movie,
              cxt: context,
              pway: 'progress',
            ):null,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                        child: Consumer<ProgressDetailProvider>(
                          builder: (context, provider, _) {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.items.length+1,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                if (index<provider.items.length){
                                  ProgressDetail item = provider.items[index];
                                    return ProgressDetailStamp(
                                      id: item.id,
                                      movie: widget.movie,
                                      stamp: item.stamp,
                                      stampText: item.stampText,
                                      cxt: context,
                                      isCurrUser:isCurrUser,
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: 
                                        SizedBox(height: 0,),
                                    );
                                  }
                                
                                }
                              );
                          }
                        ),
                      ),
                ],
              ),

            ),
          );

  }

  Widget loadingContainer() {
    bool themeCond= Theme.of(context).scaffoldBackgroundColor==Colors.black;
    Color clr = themeCond?Color.fromARGB(255, 43, 43, 43):Color.fromARGB(255, 232, 232, 232);
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 50,
      color: clr,
    );
  }

  Future<void> DeleteData(int movie, int stamp) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.delete(Uri.parse('${Globals().url}api/ts/$movie&$stamp'),
    headers: {
        'Content-Type':'application/json; charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 204) {
      
    } else {
      // Request failed
      throw Exception('Failed to get JSON: ${response.reasonPhrase}');
      }
    }
}



  // Widget SliderLabel(double _value) => Text(
  //   _value.round().toString(),
  //   //style: TextStyle(),
  // );




              // child: Container(
              //   child: SliderTheme(
              //           data:SliderThemeData(
              //             trackHeight: 5,
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.stretch,
              //             children: [
              //               Container(
              //                 padding: EdgeInsets.symmetric(horizontal: 20),
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       children: [
              //                         // Text(_sliderValues.length.toString()),
              //                         // Text(minuteToHour(_value)),
              //                         // Expanded(
              //                         //   child: Slider(
              //                         //     activeColor: Theme.of(context).colorScheme.primary,
              //                         //     inactiveColor: Theme.of(context).colorScheme.secondary,
              //                         //     value: _value,
              //                         //     label: _value.toString(),
              //                         //     // divisions: _sliderValues.length-1,
              //                         //     min: 0,
              //                         //     max: max,
              //                         //     // divisions: _sliderValues.length-1,
              //                         //     onChanged: (value)  {
              //                         //       setState(() {
              //                         //       _value = _sliderValues.reduce(
              //                         //         (a, b) =>
              //                         //         (value-a).abs() < (value-b).abs()? a: b 
              //                         //         );
              //                         //     });
              //                         //     }
              //                         //   ),
              //                         //   // child: Slider(
              //                         //   //   activeColor: Color.fromARGB(255, 202, 202, 202),
              //                         //   //   inactiveColor: Color.fromARGB(255, 38, 38, 38),
              //                         //   //   value: _sliderValues,
              //                         //   //   label: _sliderValues.toString(),
              //                         //   //   min: 0,
              //                         //   //   max: max,
              //                         //   //   // divisions: _sliderValues.length-1,
              //                         //   //   onChanged: (value) => setState(() {
              //                         //   //     this._value = value;
              //                         //   //   }),
              //                         //   // ),
              //                         // ),
              //                         // Text(minuteToHour(max)),
              //                       ],
              //                     ),
                              
              //               // Row(
              //               //   crossAxisAlignment: CrossAxisAlignment.start,
              //               //   children: [
              //               //     Text(
              //               //       minuteToHour(dt.stamp.toDouble()),
              //               //       style: TextStyle(
              //               //         color: Colors.red,
              //               //         backgroundColor: Color.fromARGB(104, 244, 67, 54)
              //               //       ),
              //               //     ),
              //               //     SizedBox(width: 5,),
              //               //     // Container(
              //               //     //   height: 100,
              //               //     //   width: MediaQuery.of(context).size.width*0.3,
              //               //     //   color: Colors.white,
              //               //     // ),
              //               //     Expanded(
              //               //       // child: TextField(
              //               //       //   controller: textController,
              //               //       //   decoration: InputDecoration(
              //               //       //     prefixIcon: Icon(Icons.photo_camera),
              //               //       //     hintText: 'What happens here?',
              //               //       //     border: OutlineInputBorder(),
              //               //       //     iconColor: Colors.white,
                                      
              //               //       //   ),
              //               //       //   keyboardType: TextInputType.multiline,
              //               //       // )

              //               //       child: Text(
              //               //         dt.stampText,
              //               //       )
              //               //     ),
              //               //     Align(
              //               //       alignment: Alignment.topRight,
              //               //       child: PopupMenuButton(
              //               //                 position: PopupMenuPosition.over,
              //               //                 iconSize: 10,
              //               //                 // splashRadius: 1,
              //               //                 color: Theme.of(context).colorScheme.secondary,
              //               //                 itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              //               //                   PopupMenuItem(
              //               //                     child: Text('Edit'),
              //               //                     value: 1,
              //               //                     ),
              //               //                   PopupMenuItem(
              //               //                     child: Text('Delete'),
              //               //                     value: 2,
              //               //                     )
              //               //                 ],
              //               //                 onSelected: (value) {
              //               //                   if (value == 1){
              //               //                     showDialog(
              //               //                       context: context,
              //               //                       builder: (context) => EditDialogueBox(
              //               //                         id:widget.id,
              //               //                         movie: widget.id, 
              //               //                         stamp: _value.toInt(),
              //               //                         cxt: context,
              //               //                         pway: widget.pway,
              //               //                         )
              //               //                       );
              //               //                   }
              //               //                   else if (value==2) {
              //               //                     DeleteData(widget.id, _value.toInt());
              //               //                   }
              //               //                 },
              //               //                 child: SizedBox(
              //               //                   width: 25,
              //               //                   height: 25,
              //               //                   child: Icon(Icons.more_vert, size: 15,),
              //               //                   ),
              //               //               ),
              //               //     )
              //               //   ],
              //               // ),
              //               ],
              //                 ),
              //               ),
              //               // ButtonBar(
              //               //   children: [
              //               //     IconButton(
              //               //       onPressed: (){
              //               //         showDialog(
              //               //           context: context, 
              //               //           builder:(context) => DialogueBox(
              //               //             id: dt.id,
              //               //             req:'POST',
              //               //             movie: dt.movie,
              //               //           )
              //               //           );
              //               //       }, 
              //               //       icon: Icon(Icons.add,size: btnsize,),
              //               //     ),
              //               //     IconButton(
              //               //       onPressed: (){
              //               //         showDialog(
              //               //           context: context, 
              //               //           builder:(context) => EditDialogueBox(movie: widget.id, stamp: _value.toInt(), id: widget.id)
              //               //           );
              //               //       }, 
              //               //       icon: Icon(Icons.edit,size: btnsize,),
              //               //     ),
              //               //     IconButton(
              //               //       onPressed: (){

              //               //       }, 
              //               //       icon: Icon(Icons.view_list, size: btnsize,),
              //               //     ),
                                
                                                       
              //               //   ],
              //               // )
              //             ],
              //           ),
              //         ),
              // ),