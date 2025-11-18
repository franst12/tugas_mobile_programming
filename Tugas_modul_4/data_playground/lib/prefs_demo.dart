// BARU: Impor dart:convert untuk jsonEncode
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsDemoPage extends StatefulWidget {
  const PrefsDemoPage({super.key});

  @override
  State<PrefsDemoPage> createState() => _PrefsDemoPageState();
}

class _PrefsDemoPageState extends State<PrefsDemoPage> {
  // MODIFIKASI: Pastikan _controller diinisialisasi di sini
  final _controller = TextEditingController();
  String _storedText = '';
  bool _darkMode = false;

  // BARU: State variabel untuk tugas
  bool _notificationsOn = true;
  String _selectedLanguage = 'id'; // Default 'id' untuk Indonesia

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // Memuat semua preferensi saat halaman dibuka
  }

  // MODIFIKASI: Ubah _loadPrefs untuk memuat data tugas
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedText = prefs.getString('greeting') ?? '';
      _darkMode = prefs.getBool('darkMode') ?? false;

      // BARU: Memuat data bahasa dan notifikasi
      _notificationsOn = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'id';
    });
  }

  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('greeting', _controller.text);
    _controller.clear();
    _loadPrefs(); // Muat ulang untuk memperbarui _storedText
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() => _darkMode = value);
  }

  // BARU: Fungsi untuk menyimpan pengaturan notifikasi
  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() => _notificationsOn = value);
  }

  // BARU: Fungsi untuk menyimpan pengaturan bahasa
  Future<void> _saveLanguage(String? newLanguage) async {
    if (newLanguage == null) return; // Jangan lakukan apa-apa jika null
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLanguage);
    setState(() => _selectedLanguage = newLanguage);
  }

  // BARU: Fungsi untuk mengekspor semua preferensi ke JSON
  Future<void> _exportToJson() async {
    // Kita baca ulang dari prefs untuk data yang paling pasti tersimpan
    final prefs = await SharedPreferences.getInstance();
    final allPrefsMap = {
      'greeting': prefs.getString('greeting') ?? '',
      'darkMode': prefs.getBool('darkMode') ?? false,
      'notifications': prefs.getBool('notifications') ?? true,
      'language': prefs.getString('language') ?? 'id',
    };

    // Ubah Map menjadi String JSON
    // Pastikan Anda sudah 'import "dart:convert";'
    final String jsonString = jsonEncode(allPrefsMap);

    // Tampilkan JSON di AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ekspor Preferensi (JSON)'),
          content: SelectableText(jsonString),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // MODIFIKASI: Pindahkan logika tema ke sini agar MaterialApp bisa dibangun ulang
    // saat _darkMode berubah
    final theme = ThemeData(
      brightness: _darkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Prefs Demo')),
        // MODIFIKASI: Gunakan ListView agar tidak overflow saat layar kecil
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Widget dari modul (Mode Gelap)
            SwitchListTile(
              title: const Text('Mode Gelap'),
              value: _darkMode,
              onChanged: _toggleDarkMode,
            ),
            const Divider(),

            // BARU: Widget untuk Tugas (Notifikasi)
            SwitchListTile(
              title: const Text('Notifikasi'),
              value: _notificationsOn,
              onChanged: _toggleNotifications,
            ),
            const Divider(),

            // BARU: Widget untuk Tugas (Bahasa)
            ListTile(
              title: const Text('Bahasa'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: _saveLanguage, // Panggil fungsi simpan
                items: const [
                  DropdownMenuItem(
                    value: 'id',
                    child: Text('Indonesia'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Widget dari modul (Salam)
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  labelText: 'Tulis salam', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _saveText, child: const Text('Simpan Salam')),
            const SizedBox(height: 12),
            Text('Tersimpan: ' + (_storedText.isEmpty ? "(kosong)" : _storedText)),
            const Divider(height: 30),

            // BARU: Widget untuk Tugas (Ekspor JSON)
            ElevatedButton(
              onPressed: _exportToJson,
              child: const Text('Ekspor ke JSON'),
            ),
          ],
        ),
      ),
    );
  }
}