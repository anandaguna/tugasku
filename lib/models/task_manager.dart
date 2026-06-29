import 'task.dart';
import 'priority_task.dart';

/// Class untuk mengelola kumpulan tugas
/// 
/// Mendemonstrasikan konsep:
/// - Encapsulation (list tasks private)
/// - Collection management
/// - CRUD operations
class TaskManager {
  // Private attribute - list berisi Task dan PriorityTask (Polymorphism)
  final List<Task> _tasks = [];

  /// Menambahkan tugas baru
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Mendapatkan semua tugas
  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }

  /// Mendapatkan tugas berdasarkan index
  Task? getTaskByIndex(int index) {
    if (index >= 0 && index < _tasks.length) {
      return _tasks[index];
    }
    return null;
  }

  /// Memperbarui tugas pada index tertentu
  bool updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      return true;
    }
    return false;
  }

  /// Menghapus tugas pada index tertentu
  bool deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      return true;
    }
    return false;
  }

  /// Menghapus semua tugas
  void deleteAllTasks() {
    _tasks.clear();
  }

  /// Mendapatkan jumlah tugas
  int getTaskCount() {
    return _tasks.length;
  }

  /// Mendapatkan jumlah tugas yang selesai
  int getCompletedTaskCount() {
    return _tasks.where((task) => task.isCompleted).length;
  }

  /// Mendapatkan tugas yang sudah diurutkan berdasarkan prioritas
  /// Untuk tugas dengan prioritas akan diurutkan, tugas biasa tetap urutan
  List<Task> getSortedTasks() {
    List<Task> sorted = List.from(_tasks);
    sorted.sort((a, b) {
      // Jika kedua adalah PriorityTask, urutkan berdasarkan prioritas
      if (a is PriorityTask && b is PriorityTask) {
        return a.getPriorityOrder().compareTo(b.getPriorityOrder());
      }
      // PriorityTask didahulukan
      if (a is PriorityTask) return -1;
      if (b is PriorityTask) return 1;
      return 0;
    });
    return sorted;
  }

  /// Mencari tugas berdasarkan judul
  List<Task> searchTasks(String keyword) {
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(keyword.toLowerCase()) ||
            task.description.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  /// Mendapatkan tugas yang belum selesai
  List<Task> getUncompletedTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  /// Mendapatkan tugas yang sudah selesai
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }
}
