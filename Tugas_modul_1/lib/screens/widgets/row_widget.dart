import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RowWidget extends StatelessWidget {
  const RowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text("Ini Row ygy", style: TextStyle(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home, size: 40, color: Colors.blue),
              Icon(Icons.wechat, size: 40, color: Colors.orange),
              Icon(Icons.person, size: 40, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}
