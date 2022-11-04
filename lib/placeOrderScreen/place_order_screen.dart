import 'dart:convert';

import 'package:amazon_universal_app/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PlaceOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;
  PlaceOrderScreen({
    super.key,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  orderDetails() {
    saveOrderDetailsForUsers({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash On Delivery",
      "orderTime": orderId,
      "orderId": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
    }).whenComplete(() {
      saveOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIDs": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash On Delivery",
        "orderTime": orderId,
        "orderId": orderId,
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "status": "normal",
      }).whenComplete(() {
        cartMethods.clearCart(context);
        //send notification (push notification)........
        //send push notification to seller about new order which placed by user
        sendNotificationToSeller(
          widget.sellerUID.toString(),
          orderId,
        );

        Fluttertoast.showToast(
            msg: "Congratulations, order has been placed successfully");

        orderId = "";
      });
    });
  }

  saveOrderDetailsForUsers(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  //notification sending to seller method
  sendNotificationToSeller(sellerUID, userOrderID) async {
    String sellerDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["sellerDeviceToken"] != null) {
        sellerDeviceToken = snapshot.data()!["sellerDeviceToken"].toString();
        print("Device Token of that seller =" + sellerDeviceToken);
        print("Device Token of that seller =" + userOrderID);
      }
    });
    notificationFormat(
      sellerDeviceToken,
      userOrderID,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(
      sellerDeviceToken, getUserOrderID, userNameWhoPlacedOrder) {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };
    Map bodyNotification = {
      'body':
          "Dear seller, New order (# $getUserOrderID) has placed Successfully from user $userNameWhoPlacedOrder. \nPleace Check Now",
      'title': "New Order",
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": getUserOrderID,
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': sellerDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/delivery.png"),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            onPressed: () {
              orderDetails();
            },
            child: const Text("Place Order Now"),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
