// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class EdetinProfile extends StatelessWidget {
  EdetinProfile({Key? key}) : super(key: key);

  TextEditingController? _namecontrole;
  TextEditingController? _phonecontrole;
  TextEditingController? _agecontrole;
  setDataTofieldtext(data) {
    return Column(
      children: [
        TextFormField(
          controller: _namecontrole = TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _agecontrole = TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _phonecontrole = TextEditingController(text: data['age']),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              child: const Text("CANCEL",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
            ),
            RaisedButton(
              onPressed: () {
                UpdateData();
              },
              color: Color.fromARGB(255, 109, 163, 111),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "Save!",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2.2, color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  UpdateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-from-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _namecontrole!.text,
      "phone": _phonecontrole!.text,
      "age": _agecontrole!.text,
    }).then((value) => Fluttertoast.showToast(
        msg: "Information saved", backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BottomNavBar()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-from-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return setDataTofieldtext(data);
            },
          ),
        ),
      ),
    );
  }
}
