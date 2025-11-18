import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

Future<String> _dbPath() async {
  final dir = await getDatabasesPath();
  return p.join(dir, 'tasks.db');
}

Future<void> ensurePreloadedDb() async {
  final path = await _dbPath();
  final exists = await File(path).exists();
  if (!exists) {
    final data = await rootBundle.load('assets/db/tasks.db');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final dir = File(path).parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await File(path).writeAsBytes(bytes, flush: true);
  }
}
