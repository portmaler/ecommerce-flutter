import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sta/Ui/bottom_nav_pages/detailproduct.dart';

class bottomnavbardetail extends StatelessWidget {
  var _produits;
  VoidCallback press;
  bottomnavbardetail(this._produits, this.press, {required});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: Offset(0, 3),
                spreadRadius: 8,
                blurRadius: 2)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                text: "\$ ${_produits.toString()}",
                style: TextStyle(
                    color: primaryColor.withOpacity(0.65),
                    fontSize: 30.00,
                    fontWeight: FontWeight.w500)),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor.withOpacity(0.65),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
            onPressed: press,
            icon: const Icon(CupertinoIcons.cart_badge_plus),
            label: const Text(
              "Add To Cart ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
