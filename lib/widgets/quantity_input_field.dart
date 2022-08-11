import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';

class QuantityInputField extends StatelessWidget {
  final PostDTO postDTO;

  const QuantityInputField({
    required this.postDTO,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return quantityInputField(postDTO);
  }

  Widget quantityInputField(PostDTO postDTO) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Semantics(
        textField: true,
        value: 'Quantity of waste',
        child: TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Input the waste count'
          ),
          keyboardType: TextInputType.number,
          validator: (value) => validateCount(value),
          onSaved: (value) {
            postDTO.quantity = int.parse(value!);
          }
        ),
      ),
    );
  }

  String? validateCount(String? count) {
    if (count == '') {
      return 'Please input a number';
    } else {
      return null;
    }
  }
}