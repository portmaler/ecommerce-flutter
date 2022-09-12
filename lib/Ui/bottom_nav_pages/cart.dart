import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sta/Core/Widget/Cart_provder.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);

  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: const Text(" Your Carts"),
        //  title: Text(Widget._produit[]),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 29, color: Colors.green.shade200),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: Badge(
                badgeContent: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users-cart-items")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection("items")
                        .snapshots(),
                    builder: (context, snapshot) {
                      String count = "0";
                      if (snapshot.hasError) {
                        count = "0";
                      }
                      if (!snapshot.hasData) {
                        count = "0";
                      }
                      count = (snapshot.data as List).length.toString();
                      return Text(count);
                    }),
                animationDuration: const Duration(milliseconds: 300),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CircleAvatar(
          //     backgroundColor: const Color.fromARGB(255, 174, 202, 175),
          //     child: IconButton(
          //       icon: const Icon(
          //         Icons.favorite_border,
          //         color: Colors.redAccent,
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users-cart-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // cart.getCounter();
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something is wrong"),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.green,
                ));
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot _documentSnapshot =
                          snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 180, 126, 123),
                                ),
                                child: Row(children: [
                                  Spacer(),
                                  SvgPicture.asset(
                                      "assets/images/trash-svgrepo-com (1).svg")
                                ]),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("users-cart-items")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection("items")
                                      .doc(_documentSnapshot.id)
                                      .delete();
                                  cart.removecounter();
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 99,
                                    child: AspectRatio(
                                      aspectRatio: 0.80,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color(0XFFF5F6F9),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Image.network(
                                            _documentSnapshot["img"]),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Text(_documentSnapshot["name"],
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text.rich(TextSpan(
                                          text:
                                              "\$${_documentSnapshot["prix"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green),
                                          children: const [
                                            TextSpan(
                                                text: " * 2",
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ])),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                      // Card(
                      //   child: ListTile(
                      //     leading: Text(_documentSnapshot["name"]),
                      //   ),
                      // );
                    }),
              );
            }),
      ),
    );
  }
}
