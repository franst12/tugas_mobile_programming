import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Impor Dio untuk error handling
import 'task_api_service.dart';
import 'task_api_model.dart';

class TaskApiPage extends StatefulWidget {
  const TaskApiPage({super.key});

  @override
  State<TaskApiPage> createState() => _TaskApiPageState();
}

class _TaskApiPageState extends State<TaskApiPage> {
  late final TaskApiService _apiService;
  List<TaskDto> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Konfigurasi Dio dengan Timeout (Penanganan Error)
    final dio = Dio(BaseOptions(
      // Timeout 5 detik untuk konek
      connectTimeout: const Duration(seconds: 5),
      // Timeout 5 detik untuk menerima data
      receiveTimeout: const Duration(seconds: 5),
    ));

    _apiService = TaskApiService(dio);
    _loadTasks();
  }

  /// Menampilkan SnackBar untuk Error (Penanganan Error)
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// CREATE
  Future<void> _addTask() async {
    // Di aplikasi nyata, ini akan dari dialog/textfield
    final newTask = TaskDto(
      title: 'Tugas Baru Dibuat (Random)',
      isCompleted: false,
      userId: 1,
    );

    try {
      final createdTask = await _apiService.createTask(newTask);
      setState(() {
        _tasks.insert(0, createdTask); // Tambah di atas
      });
    } on DioException catch (e) {
      _showError('Gagal menambah task: ${e.message}');
    } catch (e) {
      _showError('Terjadi error: $e');
    }
  }

  /// READ
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Kita ambil 20 data teratas saja agar tidak terlalu banyak
      final tasks = (await _apiService.getTasks()).take(20).toList();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } on DioException catch (e) {
      // Ini menangani error Timeout/Koneksi
      _showError('Gagal memuat data: ${e.message}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showError('Terjadi error tidak dikenal: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// UPDATE
  Future<void> _toggleComplete(TaskDto task) async {
    final updatedTask = TaskDto(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted, // Balik status
      userId: task.userId,
    );

    try {
      final result = await _apiService.updateTask(task.id!, updatedTask);
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = result;
        }
      });
    } on DioException catch (e) {
      _showError('Gagal update task: ${e.message}');
    } catch (e) {
      _showError('Terjadi error: $e');
    }
  }

  /// DELETE
  Future<void> _deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      setState(() {
        _tasks.removeWhere((t) => t.id == id);
      });
    } on DioException catch (e) {
      _showError('Gagal menghapus task: ${e.message}');
    } catch (e) {
      _showError('Terjadi error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task (API)'),
        actions: [
          // Tombol Refresh untuk memuat ulang data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            leading: IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onPressed: () => _toggleComplete(task), // UPDATE
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(task.id!), // DELETE
            ),
          );
        },
      ),
      // Tombol untuk CREATE
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}