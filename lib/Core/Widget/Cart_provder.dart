import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  List _product = [];
  int get Counter => _counter;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void _setPrefItems() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    var test = await FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots();
    _product.add(test);
    log(_product.length.toString());
    _counter = _product.length;

    prefs.setInt('Carts_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('Carts_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addtotalprice(double prix) {
    _totalPrice = _totalPrice + prix;
    _setPrefItems();
    notifyListeners();
  }

  void removtotalprice(double prix) {
    _totalPrice = _totalPrice - prix;
    _setPrefItems();

    notifyListeners();
  }

  double getTotalprice() {
    _getPrefItems();
    return _totalPrice;
  }

  void addcounter() {
    _setPrefItems();
    notifyListeners();
  }

  void removecounter() {
    _setPrefItems();

    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }
}
