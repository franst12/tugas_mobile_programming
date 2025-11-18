import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'dart:math'; // BARU: Impor 'dart:math' untuk fungsi 'max'

class TaskSqflitePage extends StatefulWidget {
  const TaskSqflitePage({super.key}); //

  @override
  State<TaskSqflitePage> createState() => _TaskSqflitePageState(); //
}

class _TaskSqflitePageState extends State<TaskSqflitePage> {
  List<Map<String, dynamic>> _tasks = []; //
  final _titleCtrl = TextEditingController(); //
  final _descCtrl = TextEditingController(); //

  // --- BARU: State untuk Paging dan Search ---
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalItems = 0;
  // Hitung total halaman, pastikan minimal 1 halaman
  int get _totalPages =>
      _totalItems == 0 ? 1 : max((_totalItems / DbHelper.pageSize).ceil(), 1);
  // ------------------------------------------

  @override
  void initState() {
    super.initState(); //
    _load(); //
  }

  // BARU: Selalu dispose controller
  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // MODIFIKASI: _load() sekarang memuat data berdasarkan state
  Future<void> _load() async {
    // Ambil total item (sesuai search query)
    final total = await DbHelper.getCount(query: _searchQuery);
    // Ambil data untuk halaman (sesuai search query dan page)
    final data = await DbHelper.getAll(
      query: _searchQuery,
      page: _currentPage,
    );
    setState(() {
      _totalItems = total;
      _tasks = data;
    });
  }

  // BARU: Fungsi untuk menjalankan pencarian
  void _search() {
    // Jika query berubah, reset ke halaman 1
    if (_searchQuery != _searchCtrl.text) {
      _currentPage = 1;
    }
    setState(() {
      _searchQuery = _searchCtrl.text;
    });
    // Muat ulang data dengan query baru
    _load();
  }

  // BARU: Fungsi untuk pindah ke halaman berikutnya
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _load();
    }
  }

  // BARU: Fungsi untuk pindah ke halaman sebelumnya
  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _load();
    }
  }

  Future<void> _addTask() async {
    await DbHelper.insert({
      'title': _titleCtrl.text, //
      'description': _descCtrl.text, //
      'isCompleted': 0 //
    });
    _titleCtrl.clear(); //
    _descCtrl.clear(); //
    // MODIFIKASI: Reset ke halaman 1 agar item baru terlihat
    _currentPage = 1;
    _searchCtrl.clear();
    _searchQuery = '';
    _load(); //
  }

  Future<void> _toggleComplete(Map<String, dynamic> t) async {
    final id = t['id'] as int; //
    final newVal = (t['isCompleted'] as int) == 1 ? 0 : 1; //
    await DbHelper.update(id, {'isCompleted': newVal}); //
    _load(); //
  }

  Future<void> _delete(int id) async {
    await DbHelper.delete(id); //

    // BARU: Logika agar tidak di halaman kosong setelah delete
    // Jika item terakhir di halaman dihapus, pindah ke halaman sebelumnya
    if (_tasks.length == 1 && _currentPage > 1) {
      _currentPage--;
    }

    _load(); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task (sqflite)')), //
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12), //
          child: Column(children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')), //
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')), //
            const SizedBox(height: 8), //
            ElevatedButton(onPressed: _addTask, child: const Text('Tambah')), //
          ]),
        ),
        const Divider(),

        // --- BARU: Widget Search Bar ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cari berdasarkan judul...',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  // Panggil _search saat user menekan 'Enter' di keyboard
                  onSubmitted: (value) => _search(),
                ),
              ),
              // Tambahkan IconButton untuk clear search
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchCtrl.clear();
                  _search(); // Panggil search (dengan query kosong)
                },
              )
            ],
          ),
        ),
        // ------------------------------

        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length, //
            itemBuilder: (ctx, i) {
              final t = _tasks[i]; //
              final done = (t['isCompleted'] as int) == 1; //
              return ListTile(
                title: Text(t['title']), //
                subtitle: Text(t['description'] ?? ''), //
                leading: IconButton(
                  icon: Icon(done ? Icons.check_box : Icons.check_box_outline_blank), //
                  onPressed: () => _toggleComplete(t), //
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete), //
                  onPressed: () => _delete(t['id'] as int), //
                ),
              );
            },
          ),
        ),

        // --- BARU: Widget Paging ---
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol 'Prev' akan nonaktif jika di halaman 1
              ElevatedButton(
                onPressed: _currentPage == 1 ? null : _prevPage,
                child: const Text('Prev'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Page $_currentPage of $_totalPages'),
              ),
              // Tombol 'Next' akan nonaktif jika di halaman terakhir
              ElevatedButton(
                onPressed: _currentPage == _totalPages ? null : _nextPage,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
        // -------------------------
      ]),
    );
  }
}