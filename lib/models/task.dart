/// Base class untuk merepresentasikan data tugas umum
///
/// Class ini mendemonstrasikan konsep OOP dasar seperti:
/// - Constructor
/// - Encapsulation (private dan getter/setter)
/// - Method
class Task {
  // Private attributes
  int? _id;
  late String _title;
  late String _description;
  late bool _isCompleted;
  late DateTime _createdAt;

  // Constructor
  Task({
    int? id,
    required String title,
    required String description,
    bool isCompleted = false,
    DateTime? createdAt,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _isCompleted = isCompleted;
    _createdAt = createdAt ?? DateTime.now();
  }

  // Getter
  // ignore: unnecessary_getters_setters
  int? get id => _id;
  // ignore: unnecessary_getters_setters
  String get title => _title;
  // ignore: unnecessary_getters_setters
  String get description => _description;
  // ignore: unnecessary_getters_setters
  bool get isCompleted => _isCompleted;
  DateTime get createdAt => _createdAt;

  // ignore: unnecessary_getters_setters
  set id(int? value) => _id = value;
  // ignore: unnecessary_getters_setters
  // Setter
  set title(String value) => _title = value;
  // ignore: unnecessary_getters_setters
  set description(String value) => _description = value;

  /// Mengubah task menjadi Map agar bisa disimpan ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': _title,
      'description': _description,
      'isCompleted': _isCompleted ? 1 : 0,
      'isPriority': 0,
      'priority': null,
      'createdAt': _createdAt.toIso8601String(),
    };
  }

  /// Membuat Task biasa dari data SQLite
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }

  /// Menandai tugas sebagai selesai
  void markAsDone() {
    _isCompleted = true;
  }

  /// Menandai tugas sebagai belum selesai
  void markAsUndone() {
    _isCompleted = false;
  }

  /// Mengubah status tugas (toggle)
  void toggleCompletion() {
    _isCompleted = !_isCompleted;
  }

  /// Menampilkan informasi tugas
  /// Method ini dapat di-override oleh subclass
  String getTaskInfo() {
    return 'Judul: $_title\nDeskripsi: $_description\nStatus: ${_isCompleted ? "Selesai" : "Belum Selesai"}\nDibuat: ${_createdAt.toLocal()}';
  }

  @override
  String toString() {
    return getTaskInfo();
  }
}
