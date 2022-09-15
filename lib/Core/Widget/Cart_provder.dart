import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _quantite = 0;
  List _product = [];
  int get Counter => _quantite;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('Carts_item', _quantite);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _quantite = prefs.getInt('Carts_item') ?? 0;
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
  }

  double getTotalprice() {
    _getPrefItems();
    return _totalPrice;
  }

  void addcounter() {
    _quantite++;
    notifyListeners();
  }

  void removecounter() {
    _quantite--;

    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _quantite;
  }
}
