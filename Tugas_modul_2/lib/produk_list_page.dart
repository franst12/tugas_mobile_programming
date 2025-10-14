import 'package:flutter/material.dart';
import 'package:flutter_modul_2/detail_produk_page.dart';
import 'detail_produk_view_page.dart'; // pastikan diimpor di atas

class ProdukListPage extends StatefulWidget {
  const ProdukListPage({super.key});

  @override
  State<ProdukListPage> createState() => _ProdukListPageState();
}

class _ProdukListPageState extends State<ProdukListPage> {
  List<Map<String, dynamic>> listProduk = [];

  void _tambahProduk(Map<String, dynamic> produk) {
    setState(() {
      listProduk.add(produk);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.teal,
      ),
      body: listProduk.isEmpty
          ? const Center(
              child: Text(
                "Belum ada produk. Tekan tombol + untuk menambah.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: listProduk.length,
              itemBuilder: (context, index) {
                final produk = listProduk[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(produk['nama']),
                    subtitle: Text("Rp ${produk['harga']}"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      DetailProdukViewPage.show(context, produk);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProdukPage(onSave: _tambahProduk),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _tampilkanDetail(BuildContext context, Map<String, dynamic> produk) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(produk['nama']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Harga: Rp ${produk['harga']}"),
              const SizedBox(height: 8),
              Text("Deskripsi: ${produk['deskripsi']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
