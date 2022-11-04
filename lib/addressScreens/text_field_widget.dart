import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TextFieldAddressWidget extends StatelessWidget {
  String? hint;
  TextEditingController? controller;

  TextFieldAddressWidget({
    super.key,
    this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Fields can not be empty" : null,
      ),
    );
  }
}
