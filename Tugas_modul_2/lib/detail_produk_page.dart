import 'package:flutter/material.dart';

class DetailProdukPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? produk; // menerima data produk lama (opsional)

  const DetailProdukPage({super.key, required this.onSave, this.produk});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // kalau ada produk lama, isi ke TextField
    if (widget.produk != null) {
      _namaController.text = widget.produk!['nama'] ?? '';
      _hargaController.text = widget.produk!['harga'] ?? '';
      _deskripsiController.text = widget.produk!['deskripsi'] ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _simpanProduk() {
    final nama = _namaController.text.trim();
    final harga = _hargaController.text.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (nama.isEmpty || harga.isEmpty || deskripsi.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom harus diisi')));
      return;
    }

    final produkBaru = {'nama': nama, 'harga': harga, 'deskripsi': deskripsi};

    widget.onSave(produkBaru);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isViewOnly = widget.produk != null; // kalau ada produk, mode lihat

    return Scaffold(
      appBar: AppBar(
        title: Text(isViewOnly ? 'Detail Produk' : 'Tambah Produk'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              enabled: !isViewOnly, // kalau mode lihat, tidak bisa edit
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hargaController,
              enabled: !isViewOnly,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deskripsiController,
              enabled: !isViewOnly,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            if (!isViewOnly)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _simpanProduk,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Produk'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
