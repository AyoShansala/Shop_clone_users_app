import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assistant_methods/cart_methods.dart';

SharedPreferences? sharedPreferences;
final itemsImagesList = [
  "slider/0.jpg",
  "slider/1.jpg",
  "slider/2.jpg",
  "slider/3.jpg",
  "slider/4.jpg",
  "slider/5.jpg",
  "slider/6.jpg",
  "slider/7.jpg",
  "slider/8.jpg",
  "slider/9.jpg",
  "slider/10.jpg",
  "slider/11.jpg",
  "slider/12.jpg",
  "slider/13.jpg",
];

CartMethods cartMethods = CartMethods();

double countStarsRating = 0.0;
String titleStarsRating = "";

String fcmServerToken =
    "key=AAAAcbcWyUE:APA91bEVY1Q8ZqapvD9BSuTEulW_rpxsO69bPQRZDqS9u0EW4S37XNyM0Zsk-AqsZKx6aTqiI0okc9qb4tP799uRvebeBlSrTfQf3toDPLTobNnV3E8pDct2_dPv0W9BvD-4DyMdzlL9";
