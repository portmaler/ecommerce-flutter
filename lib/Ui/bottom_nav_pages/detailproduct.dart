import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sta/Core/Widget/Cart_provder.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottomnavbardetail.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailProduit extends StatefulWidget {
  // ignore: prefer_final_fields, prefer_typing_uninitialized_variables
  final _produits;
  const DetailProduit(this._produits, {Key? key}) : super(key: key);

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

 List mycolors = <Color>[
  Colors.yellow,
  Colors.black,
  Colors.blueAccent,
  Colors.red,
  Colors.green,
  Colors.orange,
];
 Color primaryColor = mycolors[0];

class _DetailProduitState extends State<DetailProduit> {
  // final cart = Provider.of<CartProvider>(context, listen: false);
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._produits["name"],
      "prix": widget._produits["prix"],
      "img": widget._produits["img"],
    }).then((value) {
      print("add to cart");
      // cart.addtotalprice(double.parse(widget._produits["prix"]));
      //cart.addcounter();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future addToFavorite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favorite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._produits["name"],
      "prix": widget._produits["prix"],
      "img": widget._produits["img"],
    }).then((value) {
      print("add to favorite");
      // cart.addtotalprice(double.parse(widget._produits["prix"]));
      //cart.addcounter();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  // List<Color> listcolors = [
  //   Colors.red,
  //   Colors.green,
  //   // Colors.black,
  //   const Color.fromARGB(255, 5, 60, 85),
  //   Colors.grey,
  //   Colors.indigo,
  //   Colors.white
  // ];

  // void increment() {
  //   setState(() {

  //   });
  // }

  // void decrement() {
  //   setState(() {
  //     i--;
  //   });
  // }

  bool _isfavorite = false;
  int _isfavoritcount = 0;
  void _favorite() {
    setState(() {
      if (_isfavorite) {
        _isfavoritcount -= 1;
        _isfavorite = false;
      } else {
        addToFavorite();
        _isfavoritcount += 1;
        _isfavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    int i = cart.getCounter();
    void increment() {
      setState(() {
        i++;
      });
    }

    void decrement() {
      setState(() {
        // i--;
      });
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 174, 202, 175),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const BottomNavBar(),
                    ));
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
          ),
          title: Text(widget._produits['name']),
          //  title: Text(Widget._produit[]),
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 29, color: Colors.green.shade200),
          actions: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(
                child: Badge(
                  badgeContent:
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("users-cart-items")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            String count = "0";
                            if (snapshot.hasError) {
                              const Text("Errour");
                            }
                            if (!snapshot.hasData) {
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ),
                              );
                            }
                            // count = (snapshot.data as List).length.toString();
                            //      log(snapshot.data!.docs.length.toString());
                            return Text(
                                snapshot.data?.docs.length.toString() ?? '');
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
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 200,
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: ClipRect(
                        child: ColorFiltered(
                          colorFilter:
                              ColorFilter.mode(primaryColor, BlendMode.hue),
                          child: PhotoView(
                            backgroundDecoration:
                                const BoxDecoration(color: Colors.white),
                            imageProvider:
                                NetworkImage(widget._produits['img']),
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: PhotoViewComputedScale.covered * 0.8,
                            enableRotation: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: _favorite,
                      icon: (_isfavorite
                          ? const Icon(
                              Icons.favorite,
                              size: 35,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              size: 35,
                              color: Colors.red,
                            )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                text: widget._produits["name"],
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              },
                              initialRating: 4,
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20,
                              onRatingUpdate: (index) {},
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            Row(
                              children: [
                                Container(
                                  //padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: const Offset(0, 3))
                                      ]),
                                  child: IconButton(
                                    onPressed: decrement,
                                    icon: const Icon(CupertinoIcons.minus),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  cart.getCounter().toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  //padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: const Offset(0, 3))
                                      ]),
                                  child: IconButton(
                                    onPressed: increment,
                                    icon: const Icon(CupertinoIcons.add),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                text: widget._produits["namee"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ))),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Size :",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int i = 40; i < 46; i++)
                                  Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                              color:
                                                  Colors.grey.withOpacity(0.5))
                                        ]),
                                    child: Text(
                                      i.toString(),
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 20),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Colors :",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: mycolors.length,
                                      itemBuilder: (context, index) {
                                        return buildIconBtn(mycolors[index]);
                                      }),
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     for (var i = 0; i < 6; i++)
                              //       buildIconBtn(mycolors[i])
                              //   ],
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: bottomnavbardetail(
          widget._produits['prix'],
          () {
            addToCart();
          },
        ));
  }

  Widget buildIconBtn(Color myColor) => Container(
        child: Stack(
          children: [
            Positioned(
              top: 12.5,
              left: 12.5,
              child: Icon(
                Icons.check,
                size: 20,
                color: primaryColor == myColor ? myColor : Colors.transparent,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.circle,
                color: myColor.withOpacity(0.65),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  primaryColor = myColor;
                });
              },
            ),
          ],
        ),
      );
}
