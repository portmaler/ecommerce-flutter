import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/View/Login_page.dart';
import 'package:flutter_sta/Ui/View/route.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScren extends StatefulWidget {
  const SplashScren({Key? key}) : super(key: key);

  @override
  State<SplashScren> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  @override
  void initState()  {
    Timer(const Duration(microseconds: 300), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("userId");
      if (token != null) {
        print("token : $token");
        Get.to(const BottomNavBar());
      } else {
        Get.to(LoginPage());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 202, 175),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "E-commerce",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
