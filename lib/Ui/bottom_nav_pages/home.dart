import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/View/screen/search_screen.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/detailproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _carouselImages = [];
  // ignore: non_constant_identifier_names
  final List _Produits = [];

  var _dotposition = 0;
  final TextEditingController _searchController = TextEditingController();

  fetchCarouselImages() async {
    var _firestoreInstancee = FirebaseFirestore.instance;
    QuerySnapshot qrs =
        await _firestoreInstancee.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qrs.docs.length; i++) {
        _carouselImages.add(
          qrs.docs[i]["img"],
        );
        print(qrs.docs[i]["img"]);
      }
    });
    return qrs.docs;
  }

  fetchProduit() async {
    var _firestoreInstancee = FirebaseFirestore.instance;
    QuerySnapshot qrs = await _firestoreInstancee.collection("produits").get();
    setState(() {
      for (int j = 0; j < qrs.docs.length; j++) {
        _Produits.add({
          "img": qrs.docs[j]["img"],
          "name": qrs.docs[j]["name"],
          "prix": qrs.docs[j]["prix"],
          "type": qrs.docs[j]["type"],
          "descciption": qrs.docs[j]["description"],
          "namee": qrs.docs[j]["namee"],
        });
        print(qrs.docs[j]["description"]);
      }
    });
    return qrs.docs;
  }

  String? token;
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
  }

  @override
  void initState() {
    getToken();
    fetchCarouselImages();
    fetchProduit();
    super.initState();
  }

  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            // name = val;
                            // print(name);
                          });
                        },
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Search(name)));
                    },
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 174, 202, 175),
                        ),
                        child: const Center(
                          child: Icon(Icons.search),
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),

            AspectRatio(
              aspectRatio: 2.5,
              child: CarouselSlider(
                items: _carouselImages
                    .map((item) => Stack(children: [
                          Container(
                            height: 600,
                            width: 500,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(item),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 99,
                            ),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 174, 202, 175),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Text(
                                  "Buy Now".toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )
                        ]))
                    .toList(),
                options: CarouselOptions(
                  height: 700,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  //reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 900),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (val, carouselPageChangeReason) {
                    setState(() {
                      _dotposition = val;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: DotsIndicator(
                dotsCount: _carouselImages.isEmpty ? 1 : _carouselImages.length,
                position: _dotposition.toDouble(),
                decorator: DotsDecorator(
                    activeColor: Colors.green,
                    color: Colors.green.shade200,
                    spacing: const EdgeInsets.all(2),
                    activeSize: const Size(8, 8),
                    size: const Size(6, 6)),
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       print(_Produits);
            //     },
            //     child: Text("ok"))
            const SizedBox(
              height: 29,
            ),

            SizedBox(
              height: 55,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _Produits.length,
                  itemBuilder: (_, index) {
                    return Container(
                      //color: Colors.green,
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                _Produits[index] == 0
                                    ? Colors.red
                                    : const Color.fromARGB(255, 174, 202, 175),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  _Produits[index] == 1
                                      ? Colors.red
                                      : Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: const Color.fromARGB(
                                        255, 174, 202, 175),
                                    child:
                                        Image.network(_Produits[index]["img"]),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("${_Produits[index]["type"]}")
                              ],
                            ),
                          )),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                      text: "New Men's",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _Produits.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailProduit(
                                    _Produits[index],
                                  )));
                        },
                        child: Card(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 6),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    _Produits[index]["img"],
                                    height: 90,
                                    width: double.infinity,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: _Produits[index]["type"],
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.green))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: _Produits[index]["name"],
                                          style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.black))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text:
                                                  "\$ ${_Produits[index]["prix"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                  color: Color.fromARGB(
                                                      255, 174, 202, 175)))),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          width: 47,
                                          //color: Colors.red,
                                          child: const Icon(Icons.add),
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {},
                                      //   child: const Icon(
                                      //     Icons.add,
                                      //     color: Colors.white,
                                      //   ),
                                      //   style: ButtonStyle(
                                      //       foregroundColor:
                                      //           MaterialStateProperty.all<
                                      //               Color>(
                                      //         _Produits[index] == 0
                                      //             ? Colors.red
                                      //             : const Color.fromARGB(
                                      //                 255, 174, 202, 175),
                                      //       ),
                                      //       backgroundColor:
                                      //           MaterialStateProperty.all<Color>(
                                      //               _Produits[index] == 1
                                      //                   ? Colors.red
                                      //                   : Colors.white),
                                      //       shape: MaterialStateProperty.all<
                                      //               RoundedRectangleBorder>(
                                      //           RoundedRectangleBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       20)))),
                                      // )
                                    ],
                                  ),
                                ]),
                          ),
                          color: Colors.grey.shade200,
                        ),
                      );
                    }),
              ),
            ),
            // Expanded(
            //     child: Container(
            //   child: StreamBuilder(
            //       stream: FirebaseFirestore.instance
            //           .collection("produits")
            //           .where("name", isGreaterThanOrEqualTo: name)
            //           .snapshots(),
            //       builder: (BuildContext context,
            //           AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (snapshot.hasError) {
            //           return const Center(
            //             child: Text("Somtigns has erour"),
            //           );
            //         }
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return const Center(
            //             child: CircularProgressIndicator(
            //               color: Colors.green,
            //             ),
            //           );
            //         }
            //         if (snapshot.data!.docs.length > 0) {
            //           return ListView(
            //             children:
            //                 snapshot.data!.docs.map((DocumentSnapshot doc) {
            //               Map<String, dynamic> data =
            //                   doc.data() as Map<String, dynamic>;
            //               return Card(
            //                 elevation: 5,
            //                 child: ListTile(
            //                   title: Text(data["name"]),
            //                   leading: Image.network(data["img"]),
            //                 ),
            //               );
            //             }).toList(),
            //           );
            //         }
            //         return  Center() ;
            //       }),
            // )),
          ],
        ),
      ),
    );
  }
}
