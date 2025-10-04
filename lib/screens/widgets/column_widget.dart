import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: const [
        Text("Ini Column ygy", style: TextStyle(fontSize: 18)),
        Icon(Icons.home, size: 40, color: Colors.blue),
        Icon(Icons.wechat, size: 40, color: Colors.orange),
        Icon(Icons.person, size: 40, color: Colors.green),
      ],
    );
  }
}
