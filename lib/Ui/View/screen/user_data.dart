import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/bottom_navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _datebriController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List<String> gendre = ["femme", "homme", "autre"];
  Future<void> _selectDateFormePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 20),
        firstDate: DateTime(DateTime.now().year - 30),
        lastDate: DateTime(DateTime.now().year));
    if (picked != null) {
      setState(() {
        _datebriController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  late DatabaseReference dbref;

  // void initState() {
  //   dbref = FirebaseDatabase.instance.ref().child("Users");

  //   super.initState();
  // }

  sendUserDatatoDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-from-data");
    return _collectionRef.doc(currentUser!.email).set({
      "name": _nameController.text,
      "phone": _phoneController.text,
      "datebr": _datebriController.text,
      "genre": _genreController.text,
      "age": _ageController.text,
    }).then((value) {
      
      Fluttertoast.showToast(msg: "User add", backgroundColor: Colors.red);
      return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ));
    })
        // ignore: avoid_print
        .catchError((error) => print(" !!!!!!!!!!erreur !!!!!!!!!!!!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Submit the form to continu",
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 174, 202, 175),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "d'ont share your information with anyone",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: "Entrer your name "),
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "entrer your phone "),
                controller: _phoneController,
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                keyboardType: TextInputType.datetime,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "date of brith ",
                    suffixIcon: IconButton(
                        onPressed: () => _selectDateFormePicker(context),
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.green,
                        ))),
                controller: _datebriController,
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                controller: _genreController,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "choose youre genre",
                    suffixIcon: DropdownButton<String>(
                      items: gendre.map((String e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          // ignore: unnecessary_new
                          child: new Text(e),
                          onTap: () {
                            setState(() {
                              _genreController.text = e;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (__) {},
                    )),
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "entrer your age "),
                controller: _ageController,
              ),
              ElevatedButton(
                  onPressed: () {
                    sendUserDatatoDB();
                    // Map<String, String> Users = {
                    //   "name": _nameController.text,
                    //   "phone": _phoneController.text,
                    //   "datebr": _datebriController.text,
                    //   "genre": _genreController.text,
                    //   "age": _ageController.text,
                    // };
                    // dbref.push().set(Users);
                  },
                  child: const Text(
                    "add",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
