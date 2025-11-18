import 'package:data_playground/task_dao.dart';
import 'package:flutter/material.dart';
import 'app_database.dart';
import 'task_entity.dart';

class TaskFloorPage extends StatefulWidget {
  const TaskFloorPage({super.key}); // [cite: 375]

  @override
  State<TaskFloorPage> createState() => _TaskFloorPageState(); // [cite: 377]
}

class _TaskFloorPageState extends State<TaskFloorPage> {
  late final Future<AppDatabase> _dbFuture; // [cite: 379]
  // BARU: Kita akan menyimpan DAO-nya, bukan databasenya
  late final TaskDao _taskDao;

  final _titleCtrl = TextEditingController(); // [cite: 380]
  final _descCtrl = TextEditingController(); // [cite: 381]

  // HAPUS: Kita tidak perlu lagi state list manual
  // List<Task> tasks = [];

  @override
  void initState() {
    super.initState(); // [cite: 387]
    // MODIFIKASI: Panggil fungsi baru untuk inisialisasi
    _initDatabase();
  }

  // BARU: Fungsi untuk inisialisasi database dan DAO
  Future<void> _initDatabase() async {
    // [cite: 388]
    final db = await $FloorAppDatabase.databaseBuilder('app_floor.db').build();
    setState(() {
      _taskDao = db.taskDao;
    });
  }

  // HAPUS: Fungsi _load() tidak diperlukan lagi
  // Future<void> _load() async { ... } [cite: 389-395]

  Future<void> _add() async {
    // MODIFIKASI: Gunakan _taskDao secara langsung
    await _taskDao.insertTask(Task(
      title: _titleCtrl.text,
      description: _descCtrl.text,
    )); // [cite: 398-399]

    _titleCtrl.clear(); // [cite: 401]
    _descCtrl.clear(); // [cite: 401]

    // HAPUS: _load() tidak perlu dipanggil
    // await _load(); [cite: 402]
  }

  Future<void> _toggle(Task t) async {
    // MODIFIKASI: Gunakan _taskDao secara langsung
    await _taskDao.updateTask(Task(
      id: t.id,
      title: t.title,
      description: t.description,
      isCompleted: !t.isCompleted,
    )); // [cite: 405]

    // HAPUS: _load() tidak perlu dipanggil
    // await _load(); [cite: 406]
  }

  Future<void> _delete(Task t) async {
    // MODIFIKASI: Gunakan _taskDao secara langsung
    await _taskDao.deleteTask(t); // [cite: 412]

    // HAPUS: _load() tidak perlu dipanggil
    // await _load(); [cite: 413]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task (Floor)')), // [cite: 417]
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12), // [cite: 420]
          child: Column(children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')), // [cite: 422-424]
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')), // [cite: 425-426]
            const SizedBox(height: 8), // [cite: 427]
            ElevatedButton(onPressed: _add, child: const Text('Tambah')), // [cite: 428]
          ]),
        ),
        const Divider(), // [cite: 431]

        // --- MODIFIKASI UTAMA DI SINI ---
        Expanded(
          // BARU: Gunakan StreamBuilder
          // Ini akan "mendengarkan" perubahan dari _taskDao.findAll()
          child: StreamBuilder<List<Task>>(
            // Pastikan _taskDao sudah terinisialisasi
            stream: _taskDao.findAll(),
            builder: (context, snapshot) {
              // Saat data sedang dimuat
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Jika ada error
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // Jika tidak ada data
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data task.'));
              }

              // Jika data ada, simpan di variabel 'tasks'
              final tasks = snapshot.data!;

              // Gunakan ListView.builder seperti sebelumnya
              return ListView.builder(
                itemCount: tasks.length, // [cite: 434-435]
                itemBuilder: (ctx, i) {
                  final t = tasks[i]; // [cite: 437]
                  return ListTile(
                    title: Text(t.title), // [cite: 439]
                    subtitle: Text(t.description ?? ''), // [cite: 440]
                    leading: IconButton(
                      icon: Icon(t.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank), // [cite: 442-443]
                      onPressed: () => _toggle(t), // [cite: 445]
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(t), // [cite: 446-447]
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}