import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  var inputtext = "";
  Search(this.inputtext);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                  widget.inputtext = value;
                  print(widget.inputtext);
                });
              },
            ),
            Expanded(
                child: Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("produits")
                      .where("name".toString().toLowerCase())
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
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                       
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(doc["name"]),
                            leading: Image.network(doc["img"]),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ))
          ],
        ),
      )),
    );
  }
}
