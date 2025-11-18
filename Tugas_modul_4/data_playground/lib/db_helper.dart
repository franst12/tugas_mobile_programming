import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static const dbName = 'tasks.db'; // [cite: 157]
  static const dbVersion = 1; // [cite: 159]
  static const table = 'tasks'; // [cite: 160]

  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath(); // [cite: 162]
    final path = join(dbPath, dbName); // [cite: 163]

    // [cite: 164-171]
    return openDatabase(path, version: dbVersion, onCreate: (db, v) async {
      await db.execute('''CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )''');
    });
  }

  static Future<int> insert(Map<String, dynamic> task) async {
    final db = await _open(); // [cite: 173]
    return db.insert(table, task); // [cite: 174]
  }

  // --- MODIFIKASI DIMULAI DI SINI ---

  // BARU: Tentukan berapa item per halaman
  static const int pageSize = 5;

  /// Mengambil daftar task dengan Paging dan Search
  static Future<List<Map<String, dynamic>>> getAll({
    String query = '', // Parameter baru untuk pencarian
    int page = 1,       // Parameter baru untuk halaman
  }) async {
    final db = await _open(); // [cite: 178]

    // Tentukan offset berdasarkan halaman
    final offset = (page - 1) * pageSize;

    // Persiapkan klausa WHERE untuk pencarian
    String? whereClause;
    List<dynamic>? whereArgs;

    if (query.isNotEmpty) {
      whereClause = 'title LIKE ?';
      whereArgs = ['%$query%']; // %query% berarti mengandung query
    }

    return db.query(
      table,
      where: whereClause,   // Terapkan filter pencarian
      whereArgs: whereArgs,
      orderBy: 'id DESC', // [cite: 179]
      limit: pageSize,     // Terapkan batas Paging
      offset: offset,       // Terapkan offset Paging
    );
  }

  /// BARU: Fungsi untuk menghitung total item (untuk Paging)
  static Future<int> getCount({String query = ''}) async {
    final db = await _open();

    String? whereClause;
    List<dynamic>? whereArgs;

    if (query.isNotEmpty) {
      whereClause = 'title LIKE ?';
      whereArgs = ['%$query%'];
    }

    // `count(*)` adalah cara SQL untuk menghitung jumlah baris
    final result = await db.query(
      table,
      columns: ['COUNT(*) as count'], // Hanya ambil kolom 'count'
      where: whereClause,
      whereArgs: whereArgs,
    );

    // Kembalikan hasil hitungan
    if (result.isNotEmpty) {
      return (result.first['count'] as int?) ?? 0;
    }
    return 0;
  }

  // --- MODIFIKASI BERAKHIR DI SINI ---


  static Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await _open(); // [cite: 180]
    return db.update(table, data, where: 'id=?', whereArgs: [id]); // [cite: 182]
  }

  static Future<int> delete(int id) async {
    final db = await _open(); // [cite: 184]
    return db.delete(table, where: 'id=?', whereArgs: [id]); // [cite: 185]
  }
}