import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttert/pages/globals.dart';

void printT() async {
  User user = FirebaseAuth.instance.currentUser!;
  String token = await user.getIdToken();
  print(token);
}
