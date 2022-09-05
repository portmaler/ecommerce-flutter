
 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/View/Login_page.dart';


class SplashScren extends StatefulWidget {
  const SplashScren({Key? key}) : super(key: key);

  @override
  State<SplashScren> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage())));
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
