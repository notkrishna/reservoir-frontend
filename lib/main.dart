// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttert/mainpage.dart';
import 'package:fluttert/moviePostPage.dart';
import 'package:fluttert/pages/homepage.dart';
import 'package:fluttert/signup.dart';
import 'package:fluttert/tools/splashScreen.dart';
import 'package:fluttert/tools/themeProvider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Add this line

  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  // await Firebase.initializeApp();
  runApp(const MyApp());
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          // 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ));
}

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // Make the status bar transparent
  // ));
    return GestureDetector(
      onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        themeMode: ThemeMode.system,
        theme: userThemes.lightTheme,
        darkTheme: userThemes.darkTheme,
        title: 'Reservoir',
        home: SplashScreen(),
        routes:{
          '/home':(context) => HomePage(),
          '/login': (context) => SignupPage(),
          '/p/':(context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args is Map<String, dynamic> && args.containsKey('post')) {
            final post = args['post'];
            return MoviePostPage(post: post);
            } else {
              return Container();
            }
          }

        }
      ),
    );
  }  
}