import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/profilepage.dart';
import 'package:fluttert/pages/saved.dart';
import 'package:fluttert/settings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class NavigationDrawer extends StatefulWidget {
  final String photoUrl;
  const NavigationDrawer({
    super.key,
    required this.photoUrl
    });

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) => GestureDetector(
                onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SingleChildScrollView( 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // buildHeader(context),
                            buildMenuItems(context)
                          ],
                        )
                      ),
                    );
               },
                child: CircleAvatar(
                  radius: 14, 
                  backgroundImage: Image.network(
                    widget.photoUrl
                    ).image,
                  
                  )
                );
  
  
  
  
  



  // Widget buildHeader(BuildContext context) {
  //   final user = Globals().user;
  //   return Container(
  //   padding: EdgeInsets.only(
  //     top: MediaQuery.of(context).padding.top,
  //   ),
  //   child: Center(
  //     child: Column(
  //       children: [
  //         CircleAvatar(
  //           radius: 50,
  //           backgroundImage: NetworkImage(
  //             Globals().userAvatar
  //             ),
  //         ),
  //         SizedBox(height: 12),
  //         Text(
  //           user.uid.toString(),
  //           style: TextStyle(
  //             fontFamily: 'Outfit',
  //              //color: Colors.white,
  //               fontSize: 20),
  //         ),
  //         SizedBox(height: 10),
  //       ],
  //     ),
  //   ),
  // );
  // }
  Widget buildMenuItems(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).colorScheme.secondary,

    ),
    // height: MediaQuery.of(context).size.height*0.3,
    padding: EdgeInsets.all(10),
        child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Your Profile',style: TextStyle(fontFamily: 'Outfit', fontSize: 20),),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            //textColor: Colors.white,
            //iconColor: Colors.white,   
          ),
          // ListTile(
          //   leading: const Icon(Icons.bookmarks),
          //   title: Text('Saved',style: TextStyle(fontFamily: 'Outfit',fontSize: 20),),
          //   onTap: (){
          //     Navigator.push(context, 
          //     MaterialPageRoute(builder: (context) => SavedPostsPage())
          //     );
          //   },
          //   //textColor: Colors.white,
          //   //iconColor: Colors.white,
          // ),
          // ListTile(
          //   leading: const Icon(Icons.lock),
          //   title: Text('Security',style: TextStyle(fontFamily: 'Outfit',fontSize: 20),),
          //   onTap: (){},
          //   //textColor: Colors.white,
          //   //iconColor: Colors.white,
          // ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Settings',style: TextStyle(fontFamily: 'Outfit',fontSize: 20),),
            onTap: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => SettingsPage())
            );
            },
            //textColor: Colors.white,
            //iconColor: Colors.white,
          ),
          ListTile(
            leading: const Icon(Icons.shield),
            title: Text('Privacy',style: TextStyle(fontFamily: 'Outfit',fontSize: 20),),
            onTap: (){},
            //textColor: Colors.white,
            //iconColor: Colors.white,
          ),
          
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: Text('About',style: TextStyle(fontFamily: 'Outfit',fontSize: 20),),
            onTap: (){},
            //textColor: Colors.white,
            //iconColor: Colors.white,
          ),
          ListTile(
            onTap:() async{
              // Unregister FCM device token
              final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
              String? auth_token = await FirebaseAuth.instance.currentUser!.getIdToken();
              String? token = await _firebaseMessaging.getToken();
              if (token != null) {
                http.delete(Uri.parse('${Globals().url}api/u/unregister-device/'), body: {
                  'registration_id': token
                }, headers: {
                  'Authorization': 'Bearer $auth_token' // Add authorization header if needed
                });
              }
              await _googleSignIn.disconnect();
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Logged out successfully', Icon(Icons.check), true));

            }, 
            leading: Icon(Icons.logout, color: Colors.red,),
            title: Text('LOGOUT',style: TextStyle(fontFamily: 'Outfit',fontSize: 20, color: Colors.red),),
            // style: ElevatedButton.styleFrom(
            //   minimumSize: Size(50, 10),
            //   padding: EdgeInsets.only(left: 60,right: 60, top: 10, bottom: 10),
            //   backgroundColor: Color.fromARGB(69, 255, 0, 0)
            // ),
            )
        ],
      )
      
    );
  

}

