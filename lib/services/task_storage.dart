import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import '../models/priority_task.dart';

/// Service untuk menyimpan dan membaca task dari database SQLite lokal.
class TaskStorage {
  static const String _databaseName = 'tugasku.db';
  static const String _tableName = 'tasks';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL,
            isPriority INTEGER NOT NULL,
            priority TEXT,
            createdAt TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  /// Menambahkan satu task baru ke SQLite.
  Future<Task> insertTask(Task task) async {
    try {
      final db = await _db;
      final data = task.toMap();
      data.remove('id');

      final id = await db.insert(_tableName, data);
      task.id = id;
      return task;
    } catch (e) {
      log('Error inserting task', error: e);
      rethrow;
    }
  }

  /// Memperbarui satu task di SQLite.
  Future<void> updateTask(Task task) async {
    try {
      if (task.id == null) {
        await insertTask(task);
        return;
      }

      final db = await _db;
      await db.update(
        _tableName,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      log('Error updating task', error: e);
      rethrow;
    }
  }

  /// Menghapus satu task dari SQLite.
  Future<void> deleteTask(Task task) async {
    try {
      if (task.id == null) {
        return;
      }

      final db = await _db;
      await db.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
    } catch (e) {
      log('Error deleting task', error: e);
      rethrow;
    }
  }

  /// Menyimpan seluruh list task ke SQLite.
  /// Method ini dipertahankan agar class lain yang sudah memakai TaskStorage
  /// tetap kompatibel.
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final db = await _db;
      await db.transaction((txn) async {
        await txn.delete(_tableName);
        for (final task in tasks) {
          await txn.insert(
            _tableName,
            task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      log('Error saving tasks', error: e);
      rethrow;
    }
  }

  /// Membaca list task dari SQLite.
  Future<List<Task>> loadTasks() async {
    try {
      final db = await _db;
      final maps = await db.query(_tableName, orderBy: 'id ASC');

      return maps.map((map) {
        if ((map['isPriority'] as int? ?? 0) == 1) {
          return PriorityTask.fromMap(map);
        }
        return Task.fromMap(map);
      }).toList();
    } catch (e) {
      log('Error loading tasks', error: e);
      return [];
    }
  }

  /// Menghapus semua task dari SQLite.
  Future<void> deleteTasks() async {
    try {
      final db = await _db;
      await db.delete(_tableName);
    } catch (e) {
      log('Error deleting tasks', error: e);
      rethrow;
    }
  }
}
