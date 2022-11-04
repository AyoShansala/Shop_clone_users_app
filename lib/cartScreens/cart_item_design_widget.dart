import 'package:amazon_universal_app/models/items.dart';
import 'package:flutter/material.dart';

class CartItemDesignWidget extends StatefulWidget {
  Items? model;
  int? quantityNumber;
  CartItemDesignWidget({
    this.model,
    this.quantityNumber,
  });

  @override
  State<CartItemDesignWidget> createState() => _CartItemDesignWidgetState();
}

class _CartItemDesignWidgetState extends State<CartItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shadowColor: Colors.white54,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              //item Image.....
              Image.network(
                widget.model!.thumbnailUrl.toString(),
                width: 140,
                height: 120,
              ),
              const SizedBox(
                width: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //titile....
                    Text(
                      widget.model!.itemTitle.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    //price: Rs/= 122..........................
                    Row(
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          "Rs/=",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.model!.price.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    //quentity:4
                    Row(
                      children: [
                        const Text(
                          "Quentity: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.quantityNumber.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
