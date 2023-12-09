import 'package:flutter/material.dart';


class InputFields extends StatefulWidget {
  const InputFields({
    super.key,
    required this.textController,
    required  this.iconData,
    required this.text
  });

  final TextEditingController textController;
  final IconData iconData;
  final String text;
  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          suffixIcon: Icon(widget.iconData),
          hintText: widget.text,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
          )
      ),
      controller: widget.textController,
    );
  }
}