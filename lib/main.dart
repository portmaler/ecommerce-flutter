import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sta/Core/Widget/Cart_provder.dart';

import 'package:flutter_sta/Ui/View/screen/SplashScren.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingletonAsync(() => SharedPreferences.getInstance());

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return ChangeNotifierProvider(
            create: (_) => CartProvider(),
            child: Builder(
              builder: (BuildContext context) {
                return MaterialApp(
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
