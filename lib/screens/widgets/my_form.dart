import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ini Form ygy", style: const TextStyle(fontSize: 18)),
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Masukkan Nama",
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? "Nama tidak boleh kosong!"
                : null,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Halo, ${_controller.text}!")),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
