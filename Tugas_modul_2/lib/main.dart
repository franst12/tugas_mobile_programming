import 'package:flutter/material.dart';
import 'package:flutter_modul_2/produk_list_page.dart';
import 'detail_produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Produk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Gunakan route sistem, jangan pakai home: bersamaan
      initialRoute: '/',
      routes: {
        '/': (context) => const ProdukListPage(),
        '/detail': (context) => DetailProdukPage(onSave: (produk) {}),
      },
    );
  }
}
