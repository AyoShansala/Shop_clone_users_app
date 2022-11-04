import 'package:amazon_universal_app/global/global.dart';
import 'package:flutter/cupertino.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter =
      sharedPreferences!.getStringList("userCart")!.length - 1;
  int get count => cartListItemCounter;
  Future<void> showCartListItemsNumber() async {
    cartListItemCounter =
        sharedPreferences!.getStringList("userCart")!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
