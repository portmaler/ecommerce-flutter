// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/View/Login_page.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/editprofile.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

final user = FirebaseAuth.instance.currentUser!;

class _ProfileState extends State<Profile> {
  List<dynamic> _docIDS = [];

  Stream<dynamic> getProfileInfo() {
    dynamic data;
    try {
      data = FirebaseFirestore.instance
          .collection("users-from-data")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .snapshots();
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  fetchProfile() async {
    await FirebaseFirestore.instance
        .collection("users-from-data")
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              _docIDS.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    fetchProfile();

    super.initState();
  }

  setDataTofieldtext(data) {
    return RichText(
        text: TextSpan(
      text: data['name'],
      style: const TextStyle(
        fontSize: 22, // 22
        color: Color(0xFF202E2E),
      ),
    ));
  }

  Future<void> logoutUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF84AB5C),
        leading: SizedBox(),
        // On Android it's false by default
        centerTitle: true,
        title: const Text("Profile"),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EdetinProfile()));
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, //16
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: 240, // 240
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: 150, //150
                color: const Color(0xFF84AB5C),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10), //10
                    height: 140, //140
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 8, //8
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/profile.jpeg"),
                      ),
                    ),
                  ),

                  StreamBuilder(
                    stream: getProfileInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        log(snapshot.error.toString());
                      }

                      var data = snapshot.data;
                      if (data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return setDataTofieldtext(data);
                    },
                  ),

                  const SizedBox(height: 5), //5
                  Text(
                    user.email!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8492A2),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Container(
                        height: 50,
                        child: TextButton(
                          onPressed: logoutUser,
                          child: Text(
                            "lougout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        color: Colors.orange),
                  )

                  // Container(
                  //   height: 100,
                  //   child: ElevatedButton(
                  //     onPressed: logoutUser,
                  //     style: ElevatedButton.styleFrom(
                  //         primary: const Color.fromARGB(255, 174, 202, 175),
                  //         // padding: const EdgeInsets.symmetric(
                  //         //     horizontal: 50, vertical: 10),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20))),
                  //     child: const Text(
                  //       "logout",
                  //       style: TextStyle(color: Colors.white, fontSize: 27),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

// class SizeConfig {
//    static MediaQueryData _mediaQueryData;
//   static double screenWidth;
//   static double screenHeight;
//   static double defaultSize;
//   static Orientation orientation;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData!.size.width;
//     screenHeight = _mediaQueryData!.size.height;
//     orientation = _mediaQueryData!.orientation;
//     // On iPhone 11 the defaultSize = 10 almost
//     // So if the screen size increase or decrease then our defaultSize also vary
//     defaultSize = orientation == Orientation.landscape
//         ? screenHeight! * 0.024
//         : screenWidth! * 0.024;
//   }
  
// }