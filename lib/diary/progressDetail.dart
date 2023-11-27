import 'package:flutter/material.dart';
import 'package:fluttert/diary/editDialogueBox.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:fluttert/tools/commentPostButton.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/likeButton.dart';
import 'package:provider/provider.dart';

import '../providers/listDetailProvider.dart';

class ProgressDetailStamp extends StatelessWidget {
  final String id;
  final String movie;
  final int stamp;
  final String stampText;
  final BuildContext cxt;
  final bool isCurrUser;
  const ProgressDetailStamp({
    super.key,
    required this.id,
    required this.movie,
    required this.stamp,
    required this.stampText,
    required this.cxt,
    required this.isCurrUser
    });

  @override
  Widget build(BuildContext context) {
    String minuteToHour(int min){
      double minute = min.toDouble();
      int hrs = minute~/60;
      double minutes = minute%60;
      int mins = minutes.toInt();
      return hrs.toString().padLeft(2,"0") + '\n' + mins.toString().padLeft(2,"0") + '';
    }
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Theme.of(context).colorScheme.secondary,
            color: Color.fromARGB(115, 255, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width*0.2,
            // height: 50,

            child: Text(minuteToHour(stamp),
            style: TextStyle(
              fontSize: 35
            ),
            textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 10,),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 125,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage('https://lumiere-a.akamaihd.net/v1/images/cotr_3d522a4d.jpeg?region=0%2C2%2C1430%2C805'),
                        // image: NetworkImage('https://media3.giphy.com/media/B1CrvUCoMxhy8/giphy.gif'),

                        fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(
                      // Color.fromARGB(255, 0, 0, 0).withOpacity(0.99), 
                      //   BlendMode.dstATop
                      //   ),
                      ),
                    ),
                  ),
                SizedBox(height: 10,),

                SizedBox(
                  width: 250,
                  child: Text(
                    stampText,
                    textAlign: TextAlign.justify,
                    ),
                  
                  ),

                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    // ElevatedButton.icon(
                    //   onPressed: null, 
                    //   icon:Icon(Icons.favorite,size: 16,),
                    //   label: Text('203'),
                    // ),
                    CommentPostButtonWidget(type: 'ts', post: id, commentCount: 0),
                    isCurrUser?
                    ElevatedButton(
                      onPressed: (){
                        showModalBottomSheet(
                              context: context, 
                              builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.18,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        // height: MediaQuery.of(context).size.height*0.3,
                                        padding: EdgeInsets.all(10),
                                            child: Column(
                                            children: [
                                               ListTile(
                                                leading: const Icon(Icons.edit),
                                                title: Text('Edit',style: TextStyle(fontFamily: 'Outfit', fontSize: 20),),
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context)=>
                                                      EditDialogueBox(
                                                      id:id,
                                                      movie: movie, 
                                                      stamp: stamp,
                                                      cxt: cxt,
                                                      pway: 'progress',
                                                      )
                                                    )
                                                  );
                                                  // Navigator.pop(context);
                                                },
                                                //textColor: Colors.white,
                                                //iconColor: Colors.white,   
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.delete, color: Colors.pink,),
                                                title: Text('Remove',style: TextStyle(color:Colors.pink,fontFamily: 'Outfit', fontSize: 20),),
                                                onTap: (){
                                                  Provider.of<ProgressDetailProvider>(cxt,listen: false).DeleteData(cxt, id, movie, stamp);
                                                  Navigator.pop(context);
                                                },
                                                //textColor: Colors.white,
                                                //iconColor: Colors.white,   
                                              ),
                                            ],
                                          )
                                          
                                        );
                              }
                            );
                      }, 
                      child: Icon(Icons.more_vert, size: 16,)
                      ):
                      const SizedBox.shrink(),
              //     LikeButton(
              //       isLiked: true, 
              //       likeCount: 203, 
              //       type: 'ts', 
              //       post: 12, 
              //       cxt: context
              //     )
                  ],
                ),
                SizedBox(height: 10,),

                
              ],
            ),
          )
        ],
      )
    );
  }

  void removeData(context, id, movie, stamp){
    final provider = Provider.of<ProgressDetailProvider>(cxt,listen: false);
    provider.DeleteData(context, id, movie, stamp);
  }
}