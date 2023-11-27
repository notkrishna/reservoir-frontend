import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttert/main.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  ElevatedButton socialButton(String provider, FaIcon icon){
    return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        width: 3,
                        color: Theme.of(context).iconTheme.color!,
                      ),
                      padding: EdgeInsets.symmetric(horizontal:10, vertical:15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                      // backgroundColor: Color.fromARGB(255, 255, 0, 140),
                      // foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                      try{
                        UserCredential? userCredential = await signInWithGoogle();
                        if (userCredential != null) {
                        // Successful sign-in
                        // Navigate to the next screen or perform any necessary actions
                        // You can access user information using userCredential.user property
                          navigatorKey.currentState!.popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Login successful', Icon(Icons.check), true));  


                        } else {
                          // Sign-in error
                          // Display an error message or perform any necessary actions
                          ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error occured', Icon(Icons.close), false));  
                        }
                      } catch (e) {
                        if(e is PlatformException){
                          ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error occured', Icon(Icons.close), false));  
                        } 
                        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error occured', Icon(Icons.close), false));  
                      }
                    },
                    label: Text(
                      'Continue with '+provider,
                      style: TextStyle(
                        fontSize: 18
                        ),
                      ),
                    icon: icon
                  );
  }

  SizedBox labelAni(){
    return SizedBox(
              height: 40,
              // width: 70,
              child: AnimatedTextKit(
                pause: Duration(seconds: 3),
                repeatForever: true,
                // totalRepeatCount: 100,
                animatedTexts: [
                  TyperAnimatedText(
                    'Reservoir', 
                    // cursor: '|', 
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,

                    )
                  ),
                  TyperAnimatedText(
                    'Reservoir', 
                    // cursor: '|', 
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontFamily: 'Pattaya'
                    )
                  ),

                ]

              ),
            ); 
          }    
  
  @override
  Widget build(BuildContext context) {
    // Color? SecondaryColor = Color.fromARGB(255, 18, 0, 107);
    // Color? SecondaryColor2 = Color.fromARGB(255, 18, 0, 158);
    Color? ThemeColor = Theme.of(context).scaffoldBackgroundColor;
    Color? SecondaryColor = Theme.of(context).colorScheme.secondary;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [SecondaryColor,ThemeColor]
            ),
            //borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.15,),
                SizedBox(
                  height: 300,
                  child: LottieBuilder.network('https://assets9.lottiefiles.com/packages/lf20_hpndkcil.json')),
                //     Text(
                //   "Reservoir",
                //   style: TextStyle(
                //     fontFamily: 'Galada',
                //     fontSize: 50,
                //     color: Theme.of(context).iconTheme.color
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(height: 10,),

                

                SizedBox(height: 10,),
                
                Text(
                    'LOGIN',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Poppins'
                    ),
                  ),

                // TextField(
                //   controller: emailController,
                //     style: TextStyle(
                //       //color: Colors.white,
                //       fontFamily: 'Outfit',
                //       fontSize: 20,
                //     ),
                //     decoration: InputDecoration(
                //       //fillColor: Color.fromARGB(255, 35, 35, 35),
                //       border: InputBorder.none,
                //       // suffixIcon: IconButton(
                //       //   onPressed: clearText,
                //       //   icon: const Icon(Icons.cancel),
                //       //   //color: Color.fromARGB(255, 112, 112, 112),
                //       //   ),
                //       filled: true,
                //       //fillColor: Color.fromARGB(255, 25, 25, 25),
                //       hintStyle: TextStyle(
                //         color: Colors.grey, 
                //         fontFamily: 'Outfit', 
                //         fontSize: 25
                //         ),
                //       hintText: 'email',
                //     ),
                //   ),
                //   SizedBox(height: 10,),

                //   // TextField(
                //   // controller: emailController,
                //   //   style: TextStyle(
                //   //     //color: Colors.white,
                //   //     fontFamily: 'Outfit',
                //   //     fontSize: 20,
                //   //   ),
                //   //   decoration: InputDecoration(
                //   //     //fillColor: Color.fromARGB(255, 35, 35, 35),
                //   //     border: InputBorder.none,
                //   //     // suffixIcon: IconButton(
                //   //     //   onPressed: clearText,
                //   //     //   icon: const Icon(Icons.cancel),
                //   //     //   //color: Color.fromARGB(255, 112, 112, 112),
                //   //     //   ),
                //   //     filled: true,
                //   //     //fillColor: Color.fromARGB(255, 25, 25, 25),
                //   //     hintStyle: TextStyle(
                //   //       color: Colors.grey, 
                //   //       fontFamily: 'Outfit', 
                //   //       fontSize: 25
                //   //       ),
                //   //     hintText: 'username',
                //   //   ),
                //   // ),
                //   // SizedBox(height: 10,),
                //   TextField(
                //     controller:passwordController,
                //     obscureText: true,
                //     enableSuggestions: false,
                //     autocorrect: false,
                //     style: TextStyle(
                //       //color: Colors.white,
                //       fontFamily: 'Outfit',
                //       fontSize: 20,
                //     ),
                //     decoration: InputDecoration(
                //       //fillColor: Color.fromARGB(255, 35, 35, 35),
                //       border: InputBorder.none,
                //       // suffixIcon: IconButton(
                //       //   onPressed: clearText,
                //       //   icon: const Icon(Icons.cancel),
                //       //   //color: Color.fromARGB(255, 112, 112, 112),
                //       //   ),
                //       filled: true,
                //       //fillColor: Color.fromARGB(255, 25, 25, 25),
                //       hintStyle: TextStyle(
                //         color: Colors.grey, 
                //         fontFamily: 'Outfit', 
                //         fontSize: 25
                //         ),
                //       hintText: 'password',
                //   ),
                //   ),
                //   SizedBox(height: 10,),
                //   // TextField(
                //   //   controller:passwordController,
                //   //   obscureText: true,
                //   //   enableSuggestions: false,
                //   //   autocorrect: false,
                //   //   style: TextStyle(
                //   //     //color: Colors.white,
                //   //     fontFamily: 'Outfit',
                //   //     fontSize: 20,
                //   //   ),
                //   //   decoration: InputDecoration(
                //   //     //fillColor: Color.fromARGB(255, 35, 35, 35),
                //   //     border: InputBorder.none,
                //   //     // suffixIcon: IconButton(
                //   //     //   onPressed: clearText,
                //   //     //   icon: const Icon(Icons.cancel),
                //   //     //   //color: Color.fromARGB(255, 112, 112, 112),
                //   //     //   ),
                //   //     filled: true,
                //   //     //fillColor: Color.fromARGB(255, 25, 25, 25),
                //   //     hintStyle: TextStyle(
                //   //       color: Colors.grey, 
                //   //       fontFamily: 'Outfit', 
                //   //       fontSize: 25
                //   //       ),
                //   //     hintText: 'confirm password',
                //   // ),
                //   // ),

                  SizedBox(height: 10,),
                  
                  socialButton('Google', FaIcon(FontAwesomeIcons.google)),

                  SizedBox(height: 20,),

                  // socialButton('Apple', FaIcon(FontAwesomeIcons.apple)),

                  // SizedBox(height: 20,),

                  // socialButton('Facebook', FaIcon(FontAwesomeIcons.facebookF)),

                  SizedBox(height: 160,),
                  
                  Center(
                    child: Text(
                    'Reservoir', 
                    // cursor: '|', 
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: 'Pattaya'
                    )
                  ),)
                  
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                      
                  //    labelAni(),
                  //   //  labelAni()
                     
                      
                  //   ],
                  // )
                          
              ],
            ),
          ),
        ),
      ),
    );

  }

// SnackBar flashmsg(String msg, Icon icon, bool success){
//       return SnackBar(
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 content: Container(
//                   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: success==true?Color.fromARGB(255, 0, 177, 135):Color.fromARGB(255, 147, 1, 79),
//                     // color: Color.fromARGB(255, 147, 1, 79),                              
//                     border: Border.all(
//                       width: 3,
//                       color: Colors.white
//                     )
//                   ),
//                   child: Wrap(
//                     children: [
//                       icon,
//                       Text(
//                         msg,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Lexend',
//                           fontSize: 20
//                         ),
//                         ),
//                     ],
//                   )
//                   ),
//                 // action: SnackBarAction(
//                 //   label: 'Undo',
//                 //   onPressed: () {
//                 //     // Some code to undo the change.
//                 //   },
//                 // ),
//               );
//           }

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  try {
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Error occured', Icon(Icons.close), false));  
    return null;
    }
  }


    // Future SignUp() async {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false, 
    //     builder: (context) => Center(child: CircularProgressIndicator(),)
    //   );
    //   try{
    //     await FirebaseAuth.instance.(
    //     email: emailController.text.trim(), 
    //     password: passwordController.text.trim()
    //   );
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage())
    //     );
    //   } on FirebaseAuthException catch (e) {
    //     print(e);
    //   }
    //   // navigatorKey.currentState!.popUntil((route) => route.isFirst);
    // }


}
