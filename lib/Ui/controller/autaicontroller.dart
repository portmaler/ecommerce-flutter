// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_sta/Ui/View/Login_page.dart';
// import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthController extends GetxController {
//   final TextEditingController loginEmailControlle = TextEditingController();
//   final TextEditingController loginPasswordControlle = TextEditingController();
 
//   Future<void> loginUser() async {
//     final user = await _auth.signInWithEmailAndPassword(
//         email: loginEmailControlle.text, password: loginPasswordControlle.text);
//     if (user != null) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("userId", user.user!.uid);
//       print(user.user!.uid);
//       Get.to(BottomNavBar());
//     } else {
//       print("Erour");
//     }
//   }

//   Future<void> logoutUser() async {
//      final FirebaseAuth _auth = FirebaseAuth.instance;
//     await _auth.signOut();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//     Get.offAll(LoginPage());
//   }
// }
