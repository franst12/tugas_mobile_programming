import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Ini Counter ygy", style: const TextStyle(fontSize: 18)),
        Text("Counter: $counter", style: const TextStyle(fontSize: 18)),
        ElevatedButton(onPressed: increment, child: const Text("Tambah")),
      ],
    );
  }
}
