import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double totalAmountOfCartsItems = 0;
  double get tAmount => totalAmountOfCartsItems;
  showTotalAmountOfCartItems(double totalAmount) async {
    totalAmountOfCartsItems = totalAmount;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
