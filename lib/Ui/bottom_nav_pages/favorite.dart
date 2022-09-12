import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class favorite extends StatefulWidget {
  const favorite({Key? key}) : super(key: key);

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  var inputtext = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  inputtext = value;
                  print(inputtext);
                });
              },
            ),
            Expanded(
                child: Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("produits")
                      .where("name", isLessThanOrEqualTo: inputtext)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Somtigns has erour"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ListView(
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(data["name"]),
                              leading: Image.network(data["img"]),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ))
          ],
        ),
      )),
    );
  }
}
