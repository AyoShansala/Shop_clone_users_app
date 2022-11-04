import 'package:amazon_universal_app/assistant_methods/cart_methods.dart';
import 'package:amazon_universal_app/widgets/appbar_cart_badge.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../models/items.dart';

class ItemDetailsScreen extends StatefulWidget {
  Items? model;
  ItemDetailsScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int counterLimit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(
        sellerUID: widget.model!.sellerUID.toString(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int itemCounter = counterLimit;
          List<String> itemsIDslist =
              cartMethods.seperateItemIDsFromUserCartList();

          //1.check if item exists in already in cart
          if (itemsIDslist.contains(widget.model!.itemID)) {
            Fluttertoast.showToast(msg: "Item already in the cart");
          } else {
            //2.add item incart
            cartMethods.addItemToCart(
              widget.model!.itemID.toString(),
              itemCounter,
              context,
            );
          }
        },
        label: const Text(
          "Add to Cart",
        ),
        icon: const Icon(
          Icons.add_shopping_cart_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.model!.thumbnailUrl.toString(),
            ),
            //implement the item counter
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CartStepperInt(
                  style: const CartStepperStyle(
                    deActiveBackgroundColor: Colors.red,
                    activeBackgroundColor: Colors.pinkAccent,
                    activeForegroundColor: Colors.white,
                  ),
                  count: counterLimit,
                  size: 40,
                  didChangeCount: ((value) {
                    if (value < 1) {
                      Fluttertoast.showToast(
                          msg: "The Quantity cannot be less than 1");
                      return;
                    }
                    setState(() {
                      counterLimit = value;
                    });
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 8.0,
              ),
              child: Text(
                widget.model!.itemTitle.toString() + ":",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.pinkAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 6.0,
              ),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.model!.price.toString() + " Rs/=",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 300.0),
              child: Divider(
                height: 1,
                thickness: 2,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
