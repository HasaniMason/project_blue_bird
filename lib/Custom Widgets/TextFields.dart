import 'package:flutter/material.dart';



class TextFields extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData iconData;
  final TextInputType textInputType;



  const TextFields({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.iconData,
    required this.textInputType
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
            focusColor: Colors.grey,
            fillColor: Colors.grey,
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            contentPadding: EdgeInsets.only(left: 15,bottom: 11,top: 11,right: 15),
            hintText: hintText,

            icon: Icon(iconData)
        ),
      ),
    );
  }
}