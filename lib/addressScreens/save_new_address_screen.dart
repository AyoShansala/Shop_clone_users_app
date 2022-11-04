import 'package:amazon_universal_app/addressScreens/text_field_widget.dart';
import 'package:amazon_universal_app/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SaveNewAddressScreen extends StatefulWidget {
  String? sellerUID;
  double? totalAmount;
  SaveNewAddressScreen({
    super.key,
    this.sellerUID,
    this.totalAmount,
  });

  @override
  State<SaveNewAddressScreen> createState() => _SaveNewAddressScreenState();
}

class _SaveNewAddressScreenState extends State<SaveNewAddressScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController streetNumber = TextEditingController();
  TextEditingController flatHouseNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController stateCountry = TextEditingController();
  String completeAddress = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            completeAddress = streetNumber.text.trim() +
                ", " +
                flatHouseNumber.text.trim() +
                ", " +
                city.text.trim() +
                ", " +
                stateCountry.text.trim() +
                ". ";
            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set({
              "name": name.text.trim(),
              "phoneNumber": phoneNumber.text.trim(),
              "streetNumber": streetNumber.text.trim(),
              "flatHouseNummber": flatHouseNumber.text.trim(),
              "city": city.text.trim(),
              "stateCountry": stateCountry.text.trim(),
              "completeAddress": completeAddress,
            }).then((value) {
              Fluttertoast.showToast(msg: "New shipment addres has been saved");
              formKey.currentState!.reset();
            });
          }
        },
        label: const Text("Save Now"),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Save Now Address:",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFieldAddressWidget(
                    hint: "Name",
                    controller: name,
                  ),
                  TextFieldAddressWidget(
                    hint: "Phone Number",
                    controller: phoneNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: "Street Number",
                    controller: streetNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: "Flat/House Number",
                    controller: flatHouseNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: "City",
                    controller: city,
                  ),
                  TextFieldAddressWidget(
                    hint: "State/Country",
                    controller: stateCountry,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
