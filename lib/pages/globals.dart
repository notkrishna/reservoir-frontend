import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
class Globals {
  // final String userAvatar = 'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png';
  final user = FirebaseAuth.instance.currentUser!;
  final Uri url = Uri.parse('http://192.168.1.11:8000/');
  final double moviePosterHeight = 300;
  // final Uri url = Uri.parse('http://192.168.1.6:8000/');
  // final Uri url = Uri.parse('http://10.0.2.2:8000/');
  SnackBar flashmsg(String msg, Icon icon, bool success){
      return SnackBar(
        duration: Duration(seconds: 2),
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: success==true?Color.fromARGB(255, 0, 177, 135):Color.fromARGB(255, 147, 1, 79),
                    // color: Color.fromARGB(255, 147, 1, 79),                              
                    // border: Border.all(
                    //   width: 3,
                    //   // color: Theme.of(context).iconTheme.color!,
                    // )
                  ),
                  child: Wrap(
                    children: [
                      icon,
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontSize: 20
                        ),
                        ),
                    ],
                  )
                  ),
                // action: SnackBarAction(
                //   label: 'Undo',
                //   onPressed: () {
                //     // Some code to undo the change.
                //   },
                // ),
              );
          }

}