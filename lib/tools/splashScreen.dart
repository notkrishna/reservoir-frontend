import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/mainpage.dart';
import 'package:fluttert/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/signup.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width-50,
          //   child: Lottie.network(
          //     'https://assets10.lottiefiles.com/temporary_files/jzVfLn.json'
          //     )
          //   ),
          SizedBox(
            width: MediaQuery.of(context).size.width-50,
            child: Text(
              'Reservoir',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontFamily: 'Galada'
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Loading(),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      nextScreen: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'),);
          } else if (snapshot.hasData) {
            return MainPage();
          } else {
            return SignupPage();
          }
        },
      ),
      duration: 2000,
      );
  }
}