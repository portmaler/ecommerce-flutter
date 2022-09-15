import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sta/Core/Widget/Cart_provder.dart';
import 'package:flutter_sta/Ui/View/Login_page.dart';

import 'package:flutter_sta/Ui/View/screen/SplashScren.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/home.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  try {} catch (e) {
    print("init failed " + e.toString());
  }
  runApp(const MyApp());
  // _init();
}

// _init() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString("userId");
//   if (token != null) {
//     print("token : $token");
//     Get.to(const BottomNavBar());
//   } else {
//     Get.to(LoginPage());
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getrefrensItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('quantite du produit', 0);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return ChangeNotifierProvider(
            create: (_) => CartProvider(),
            child: Builder(
              builder: (BuildContext context) {
                return GetMaterialApp(
                  title: 'Firebase e-commerce',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.grey,
                  ),
                  home: const SplashScren(),
                );
              },
            ));
      },
    );
  }
}
