import 'package:amazon_universal_app/addressScreens/address_screen.dart';
import 'package:amazon_universal_app/assistant_methods/cart_item_counter.dart';
import 'package:amazon_universal_app/assistant_methods/total_amount.dart';
import 'package:amazon_universal_app/cartScreens/cart_item_design_widget.dart';
import 'package:amazon_universal_app/global/global.dart';
import 'package:amazon_universal_app/splashScreen/my_splash_screen.dart';
import 'package:amazon_universal_app/widgets/appbar_cart_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class CartScreen extends StatefulWidget {
  String? sellerUID;
  CartScreen({this.sellerUID});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? itemQuentitiesList;
  double totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false)
        .showTotalAmountOfCartItems(0);
    itemQuentitiesList = cartMethods.seperateItemQuantitiesFromUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              cartMethods.clearCart(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MySplashScreen(),
                ),
              );
            },
            heroTag: 'btn1',
            label: const Text(
              "Clear Cart",
              style: TextStyle(fontSize: 16),
            ),
            icon: const Icon(Icons.clear_all),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => AddressScreen(
                    sellerUID: widget.sellerUID.toString(),
                    totalAmount: totalAmount.toDouble(),
                  ),
                ),
              );
            },
            heroTag: 'btn2',
            label: const Text(
              "Check out",
              style: TextStyle(fontSize: 16),
            ),
            icon: const Icon(Icons.navigate_next),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black54,
              child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: cartProvider.count == 0
                          ? Container()
                          : Text(
                              "Total Price: " +
                                  amountProvider.tAmount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          //query
          //model
          //design
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where(
                  "itemID",
                  whereIn: cartMethods.seperateItemIDsFromUserCartList(),
                )
                .orderBy("publisedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot) {
              if (dataSnapshot.hasData) {
                //display
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Items model = Items.fromJson(dataSnapshot.data.docs[index]
                          .data() as Map<String, dynamic>);
                      if (index == 0) {
                        totalAmount = 0;
                        totalAmount = totalAmount +
                            (double.parse(model.price!) *
                                itemQuentitiesList![index]);
                      } else {
                        totalAmount = totalAmount +
                            (double.parse(model.price!) *
                                itemQuentitiesList![index]);
                      }

                      if (dataSnapshot.data.docs.length - 1 == index) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          Provider.of<TotalAmount>(context, listen: false)
                              .showTotalAmountOfCartItems(totalAmount);
                        });
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CartItemDesignWidget(
                          model: model,
                          quantityNumber: itemQuentitiesList![index],
                        ),
                      );
                    },
                    childCount: dataSnapshot.data.docs.length,
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No items exixts in cart",
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
