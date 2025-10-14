import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  const CustomTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.purple),
    );
  }
}
