import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/View/Login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Future<Map<String, dynamic>> getpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      "email": prefs.getString("email"),
      "pasword": prefs.getString("pasword"),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getpref(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        }
        if (!snapshot.hasData) {
          return const LoginPage();
        }
        final userdata = snapshot.data! as Map<String, dynamic>;
        log(userdata.toString());
        return Container();
      },
    );
  }
}
