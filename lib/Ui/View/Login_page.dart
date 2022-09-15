// ignore: file_names
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sta/Ui/View/Registre.dart';

import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:flutter_sta/Ui/controller/autaicontroller.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        //print("No User found for that email");
        Fluttertoast.showToast(
            msg: "No User found for that email", backgroundColor: Colors.red);
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 202, 175),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.light,
                          color: Colors.transparent,
                        )),
                    Text(
                      "login",
                      style: TextStyle(
                          fontSize: 40, letterSpacing: 1, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Welcom Buddy ! ",
                            style: TextStyle(
                                fontSize: 22, color: Colors.green.shade100),
                          ),
                          const SizedBox(
                            height: 19,
                          ),
                          const Text(
                            "AGADIIR FATIMA",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 48,
                                width: 41,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 174, 202, 175),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      hintText: "fati@gmail.com",
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      labelText: "EMAIL",
                                      labelStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 2)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email ';
                                    }
                                    //final bool _isvalid = Email
                                    final bool _isvalid =
                                        EmailValidator.validate(
                                            _emailController.text);
                                    if (!_isvalid) {
                                      return "Email was entered incorrectly";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 38,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 48,
                                width: 41,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 174, 202, 175),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.lock_clock_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 8) {
                                      return 'Password  short';
                                    }
                                    // ignore: unnecessary_null_comparison
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter you password';
                                    }
                                    return null;
                                  },
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      hintText: "",
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      labelText: "Password",
                                      suffixIcon: _isObscure == true
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = false;
                                                });
                                              },
                                              icon:
                                                  const Icon(Icons.visibility))
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = true;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.visibility_off)),
                                      labelStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 2)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Navigator.of(context).pushReplacement(
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               const BottomNavBar()));
                                User? user = await loginUsingEmailPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
                                log(_emailController.text);
                                log(_passwordController.text);
                                log(user.toString());
                                //SharedPref.savedToken(user.toString());

                                // var token = user.toString();
                                // SharedPreferences pref =
                                //     await SharedPreferences.getInstance();
                                // pref.setString("token", token);

                                if (_formKey.currentState!.validate())
                                // if (user == null) {
                                //   Fluttertoast.showToast(
                                //       msg:
                                //           "plaise saisire votre email et votre mot de passe  .",
                                //       backgroundColor: const Color.fromARGB(
                                //           255, 214, 143, 143));
                                // }

                                // ignore: curly_braces_in_flow_control_structures
                                if (user != null) {
                                  {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString("userId", user.uid);
                                    print(user.uid);

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavBar()));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 174, 202, 175),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 27),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              const Text(
                                "d'ont have an account ? ",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Registre()));
                                  },
                                  child: const Text(
                                    "Sign IN ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 174, 202, 175),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
