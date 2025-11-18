// BARU: Impor dart:convert untuk JSON
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDemoPage extends StatefulWidget {
  const FileDemoPage({super.key}); // [cite: 106]

  @override
  State<FileDemoPage> createState() => _FileDemoPageState(); // [cite: 108]
}

class _FileDemoPageState extends State<FileDemoPage> {
  // BARU: Ganti counter dengan TextEditingController untuk profil
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  // BARU: State untuk menampilkan path file
  String _filePath = "Belum ada file";

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory(); // [cite: 112]
    // MODIFIKASI: Ubah nama file ke profile.json
    _filePath = '${dir.path}/profile.json';
    return File(_filePath); // [cite: 113]
  }

  // MODIFIKASI: Ganti nama fungsi dari _readCounter ke _readProfile
  Future<void> _readProfile() async {
    try {
      final file = await _localFile; // [cite: 116, 117]
      final content = await file.readAsString(); // [cite: 118, 119]

      // BARU: Decode JSON
      final Map<String, dynamic> data = jsonDecode(content);

      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    } catch (e) {
      // Jika file tidak ada atau error, kosongkan field
      setState(() {
        _nameController.text = '';
        _emailController.text = '';
      });
    }
  }

  // MODIFIKASI: Ganti nama fungsi dari _writeCounter ke _writeProfile
  Future<void> _writeProfile() async {
    final file = await _localFile; // [cite: 126, 127]

    // BARU: Buat Map untuk data profil
    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'email': _emailController.text,
    };

    // BARU: Encode Map ke JSON String
    final String jsonString = jsonEncode(data);

    await file.writeAsString(jsonString); // [cite: 128]

    // Tampilkan snackbar sebagai konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil disimpan di $_filePath')),
    );
  }

  // BARU: Fungsi untuk menghapus file
  Future<void> _deleteProfile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil dihapus.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File profil tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus file: $e')),
      );
    }
    // Setelah dihapus, baca ulang (yang akan mengosongkan field)
    _readProfile();
  }

  @override
  void initState() {
    super.initState(); // [cite: 133]
    _readProfile(); // [cite: 134]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Demo - Profil JSON')), // [cite: 138]
      // MODIFIKASI: Ubah body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _writeProfile,
                  child: const Text('Simpan Profil'),
                ),
                ElevatedButton(
                  onPressed: _deleteProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Hapus Profil'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}