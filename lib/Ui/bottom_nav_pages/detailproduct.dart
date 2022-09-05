
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottomnavbardetail.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/cart.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class DetailProduit extends StatefulWidget {
   // ignore: prefer_final_fields, prefer_typing_uninitialized_variables
   var _produits;
  DetailProduit(this._produits, {Key? key}) : super(key: key);

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Carts()));
    });
  }

  int i = 0;
  List<Color> listcolors = [
    Colors.orange,
    Colors.green,
    // Colors.black,
    Color.fromARGB(255, 5, 60, 85),
    Colors.grey,
    Colors.indigo,
    Colors.white
  ];

  void increment() {
    setState(() {
      i++;
    });
  }

  void decrement() {
    setState(() {
      i--;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 174, 202, 175),
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ClipRect(
                      child: PhotoView(
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.white),
                        imageProvider: NetworkImage(widget._produits['img']),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 0.8,
                        enableRotation: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      //height: double.infinity,
                      height: size.height,
                      width: size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
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
                                      "$i",
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ]),
                                        child: Text(
                                          i.toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 20),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    for (int i = 0; i < listcolors.length; i++)
                                      Container(
                                        height: 30,
                                        width: 30,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: listcolors[i],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ]),
                                      ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomnavbardetail(
          widget._produits['prix'],
          () {
            addToCart();
          },
        ));
  }
}
