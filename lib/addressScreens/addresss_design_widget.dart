import 'package:amazon_universal_app/assistant_methods/address_changer.dart';
import 'package:amazon_universal_app/assistant_methods/total_amount.dart';
import 'package:amazon_universal_app/models/address.dart';
import 'package:amazon_universal_app/placeOrderScreen/place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressDesignWidget extends StatefulWidget {
  Address? addressModel;
  int? index;
  int? value;
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  AddressDesignWidget({
    this.addressModel,
    this.index,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<AddressDesignWidget> createState() => _AddressDesignWidgetState();
}

class _AddressDesignWidgetState extends State<AddressDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white30,
      child: Column(
        children: [
          //address information.......................................
          Row(
            children: [
              Radio(
                groupValue: widget.index,
                value: widget.value,
                activeColor: Colors.pink,
                onChanged: (val) {
                  Provider.of<AddressChanger>(context, listen: false)
                      .showSelectedAddress(val);
                },
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Table(
                      children: [
                        TableRow(children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.name.toString(),
                          )
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                        TableRow(children: [
                          const Text(
                            "Phone: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.phoneNumber.toString(),
                          )
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                        TableRow(children: [
                          const Text(
                            "Complete Address: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.completeAddress.toString(),
                          )
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          //button.................
          widget.value == Provider.of<AddressChanger>(context).count
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("proceed"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      //send user to place order screen finally
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => PlaceOrderScreen(
                            addressID: widget.addressID,
                            totalAmount: widget.totalAmount,
                            sellerUID: widget.sellerUID,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
