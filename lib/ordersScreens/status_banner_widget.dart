import 'package:amazon_universal_app/sellersScreen/home_screen.dart';
import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  bool? status;
  String? orderStatus;

  StatusBanner({
    super.key,
    this.status,
    this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Sucessful" : message = "UnSuccessful";
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.purpleAccent,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => HomeScreen()),
              );
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 28,
          ),
          Text(
            orderStatus == "ended"
                ? "Parcel Deleverd $message"
                : orderStatus == "shifted"
                    ? "Parcel Shifted $message"
                    : orderStatus == "normal"
                        ? "Order Placed $message"
                        : "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
