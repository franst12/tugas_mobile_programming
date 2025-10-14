import 'package:flutter/material.dart';

class ProdukItem extends StatelessWidget {
  final Map<String, dynamic> produk;
  final VoidCallback onTap;

  const ProdukItem({super.key, required this.produk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(produk['nama']),
        subtitle: Text("Rp ${produk['harga']}"),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
