import 'task.dart';

/// Enum untuk menentukan tingkat prioritas tugas
enum Priority { low, medium, high }

/// Class untuk tugas dengan prioritas
///
/// Mendemonstrasikan konsep OOP:
/// - Inheritance (extends Task)
/// - Method Overriding (override getTaskInfo())
/// - Polymorphism (dapat diperlakukan sebagai Task)
class PriorityTask extends Task {
  late Priority _priority;

  // Constructor
  PriorityTask({
    super.id,
    required super.title,
    required super.description,
    required Priority priority,
    super.isCompleted = false,
    super.createdAt,
  }) {
    _priority = priority;
  }

  // Getter dan Setter
  // ignore: unnecessary_getters_setters
  Priority get priority => _priority;
  // ignore: unnecessary_getters_setters
  set priority(Priority value) => _priority = value;

  /// Mengubah PriorityTask menjadi Map agar bisa disimpan ke SQLite
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['isPriority'] = 1;
    map['priority'] = _priority.name;
    return map;
  }

  /// Membuat PriorityTask dari data SQLite
  factory PriorityTask.fromMap(Map<String, dynamic> map) {
    return PriorityTask(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      priority: _priorityFromString(map['priority'] as String?),
      isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }

  static Priority _priorityFromString(String? value) {
    return Priority.values.firstWhere(
      (priority) => priority.name == value,
      orElse: () => Priority.medium,
    );
  }

  /// Mendapatkan string prioritas
  String getPriorityString() {
    switch (_priority) {
      case Priority.low:
        return 'Rendah';
      case Priority.medium:
        return 'Sedang';
      case Priority.high:
        return 'Tinggi';
    }
  }

  /// Method Overriding: menampilkan informasi tugas dengan prioritas
  @override
  String getTaskInfo() {
    return '${super.getTaskInfo()}\nPrioritas: ${getPriorityString()}';
  }

  /// Mendapatkan warna berdasarkan prioritas
  /// Digunakan untuk UI
  String getPriorityColor() {
    switch (_priority) {
      case Priority.low:
        return '#4CAF50'; // Hijau
      case Priority.medium:
        return '#FFC107'; // Kuning
      case Priority.high:
        return '#F44336'; // Merah
    }
  }

  /// Mendapatkan urutan prioritas untuk sorting
  /// Tinggi = 0, Sedang = 1, Rendah = 2
  int getPriorityOrder() {
    switch (_priority) {
      case Priority.high:
        return 0;
      case Priority.medium:
        return 1;
      case Priority.low:
        return 2;
    }
  }

  @override
  String toString() {
    return getTaskInfo();
  }
}
