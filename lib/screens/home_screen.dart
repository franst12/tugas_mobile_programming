import 'package:flutter/material.dart';
import 'package:flutter_tugas_modul_1/screens/widgets/column_widget.dart';
import 'package:flutter_tugas_modul_1/screens/widgets/counter_widget.dart';
import 'package:flutter_tugas_modul_1/screens/widgets/custom_text_widget.dart';
import 'package:flutter_tugas_modul_1/screens/widgets/my_form.dart';
import 'package:flutter_tugas_modul_1/screens/widgets/row_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tugas Modul 1")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Hello World",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            RowWidget(),
            SizedBox(height: 30),
            ColumnWidget(),
            SizedBox(height: 30),
            CustomTextWidget(text: "Ini StatelessWidget ygy"),
            SizedBox(height: 30),
            CounterWidget(),
            SizedBox(height: 30),
            MyForm(),
          ],
        ),
      ),
    );
  }
}
