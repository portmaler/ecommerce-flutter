import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/cart.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/favorite.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/home.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _pages = [
    const Home(),
    const favorite(),
    const Carts(),
    const Profile(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     "E -Commerce fati",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 174, 202, 175),
        //  backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            // backgroundColor: Colors.grey
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: "Carts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (e) {
          setState(() {
            _currentIndex = e;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
