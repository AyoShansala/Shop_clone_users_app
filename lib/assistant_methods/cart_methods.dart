import 'package:amazon_universal_app/assistant_methods/cart_item_counter.dart';
import 'package:amazon_universal_app/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartMethods {
  addItemToCart(
    String? itemId,
    int itemCounter,
    BuildContext context,
  ) {
    List<String>? tempList = sharedPreferences!.getStringList("userCart");
    tempList!
        .add(itemId.toString() + ":" + itemCounter.toString()); //12234562:4

    // print("tempList =");
    // print(tempList);

    //save to firestore databse........................
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userCart": tempList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Item added sucsessfully");
      //local storage saving.............................
      sharedPreferences!.setStringList("userCart", tempList);
      //update item badge number
      Provider.of<CartItemCounter>(context, listen: false)
          .showCartListItemsNumber();
    });
  }

  //clear added items from the cart...................................
  clearCart(BuildContext context) {
    //clear in local storage
    sharedPreferences!.setStringList("userCart", ["initialValue"]);
    List<String>? emptyCartList = sharedPreferences!.getStringList("userCart");

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userCart": emptyCartList,
    }).then((value) {
      //update item badge number
      Provider.of<CartItemCounter>(context, listen: false)
          .showCartListItemsNumber();
    });
  }

  //23452367890:5 ==> 23452367890 seperate the id............................
  seperateItemIDsFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<String> itemsIDsList = [];

    for (int i = 1; i < userCartList!.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();
      var lastCharaterPositionOfItemBeforeColon = item.lastIndexOf(':');
      //4732972902
      String getItemID =
          item.substring(0, lastCharaterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //23452367890:5 ==> 5 seperate the quantities............................
  seperateItemQuantitiesFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<int> itemsQuantitiesList = [];

    print("UserCartList =");
    print(userCartList);

    for (int i = 1; i < userCartList!.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();

      //:5 split perform this
      var colonAfterCharatersList = item.split(':').toList(); // 0=[:] 1=[5]
      //5 quentity number
      var quentityNumber = int.parse(colonAfterCharatersList[1].toString());

      itemsQuantitiesList.add(quentityNumber);
    }
    print("ItemQuentitiessList =");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }

  //23452367890:5 ==> 23452367890 seperate the id............................
  seperateOrderItemIDs(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsIDsList = [];

    for (int i = 1; i < userCartList.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();
      var lastCharaterPositionOfItemBeforeColon = item.lastIndexOf(':');
      //4732972902
      String getItemID =
          item.substring(0, lastCharaterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //23452367890:5 ==> 5 seperate the quantities............................
  seperateOrderItemsQuantities(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsQuantitiesList = [];

    print("UserCartList =");
    print(userCartList);

    for (int i = 1; i < userCartList.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();

      //:5 split perform this
      var colonAfterCharatersList = item.split(':').toList(); // 0=[:] 1=[5]
      //5 quentity number
      var quentityNumber = int.parse(colonAfterCharatersList[1].toString());

      itemsQuantitiesList.add(quentityNumber.toString());
    }
    print("ItemQuentitiessList =");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }
}
