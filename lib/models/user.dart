import 'task_manager.dart';
import 'task.dart';
import 'priority_task.dart';

/// Class untuk merepresentasikan pengguna aplikasi
/// 
/// Mendemonstrasikan konsep:
/// - Relasi antar class (memiliki TaskManager)
/// - Encapsulation
/// - Business logic
class User {
  late String _name;
  late TaskManager _taskManager;

  // Constructor
  User({required String name}) {
    _name = name;
    _taskManager = TaskManager();
  }

  // Getter
  // ignore: unnecessary_getters_setters
  String get name => _name;
  TaskManager get taskManager => _taskManager;

  // ignore: unnecessary_getters_setters
  // Setter
  set name(String value) => _name = value;

  /// Membuat tugas baru
  void createTask({
    required String title,
    required String description,
    Priority? priority,
  }) {
    if (priority != null) {
      // Membuat PriorityTask
      PriorityTask task = PriorityTask(
        title: title,
        description: description,
        priority: priority,
      );
      _taskManager.addTask(task);
    } else {
      // Membuat Task biasa
      Task task = Task(
        title: title,
        description: description,
      );
      _taskManager.addTask(task);
    }
  }

  /// Melihat semua tugas (debug only)
  List<Task> getTasks() {
    return _taskManager.getAllTasks();
  }

  /// Melihat ringkasan tugas (debug only)
  String getTaskSummary() {
    int total = _taskManager.getTaskCount();
    int completed = _taskManager.getCompletedTaskCount();
    int uncompleted = total - completed;

    return 'Total: $total, Selesai: $completed, Belum: $uncompleted';
  }

  /// Mendapatkan statistik tugas
  Map<String, int> getTaskStatistics() {
    return {
      'total': _taskManager.getTaskCount(),
      'completed': _taskManager.getCompletedTaskCount(),
      'uncompleted': _taskManager.getTaskCount() - _taskManager.getCompletedTaskCount(),
    };
  }

  @override
  String toString() {
    return 'User: $_name, Total Tugas: ${_taskManager.getTaskCount()}';
  }
}
