import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/priority_task.dart';
import '../services/task_storage.dart';
import 'add_edit_task_screen.dart';
import 'settings_screen.dart';
import 'task_detail_screen.dart';

/// Halaman utama aplikasi yang menampilkan daftar tugas
class HomeScreen extends StatefulWidget {
  final User user;
  final TaskStorage storage;

  const HomeScreen({super.key, required this.user, required this.storage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugasku'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget statistik tugas
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: _buildStatisticsCard(),
          ),
          // Daftar tugas
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddEditTaskScreen(user: widget.user, storage: widget.storage),
            ),
          );
          if (mounted) {
            setState(() {});
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SettingsScreen(user: widget.user, storage: widget.storage),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  /// Widget untuk menampilkan statistik tugas
  Widget _buildStatisticsCard() {
    Map<String, int> stats = widget.user.getTaskStatistics();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Total', stats['total'].toString(), Colors.white),
        _buildStatItem(
          'Selesai',
          stats['completed'].toString(),
          Colors.greenAccent,
        ),
        _buildStatItem(
          'Belum',
          stats['uncompleted'].toString(),
          Colors.orangeAccent,
        ),
      ],
    );
  }

  /// Widget untuk satu item statistik
  Widget _buildStatItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  /// Widget untuk menampilkan daftar tugas
  Widget _buildTaskList() {
    List<Task> tasks = widget.user.taskManager.getSortedTasks();

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada tugas',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan tugas baru dengan menekan tombol +',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  /// Widget untuk card tugas
  Widget _buildTaskCard(Task task) {
    Color priorityColor = Colors.blue;
    String priorityLabel = '';

    if (task is PriorityTask) {
      priorityLabel = task.getPriorityString();
      // Parse hex color dan konversi ke Color
      String hexColor = task.getPriorityColor();
      priorityColor = Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: task.isCompleted ? Colors.grey[300]! : priorityColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) async {
                    task.toggleCompletion();
                    setState(() {});

                    try {
                      await widget.storage.updateTask(task);
                    } catch (_) {
                      task.toggleCompletion();
                      if (mounted) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengubah status tugas'),
                          ),
                        );
                      }
                    }
                  },
                  activeColor: Colors.blue,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      if (priorityLabel.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              priorityLabel,
                              style: TextStyle(
                                fontSize: 10,
                                color: priorityColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Tombol aksi
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTaskScreen(
                            user: widget.user,
                            taskIndex: widget.user.taskManager
                                .getAllTasks()
                                .indexOf(task),
                            storage: widget.storage,
                          ),
                        ),
                      ).then((_) => setState(() {}));
                    } else if (result == 'delete') {
                      _showDeleteConfirmation(task);
                    } else if (result == 'detail') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'detail',
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Detail'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 8),
              child: Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog untuk konfirmasi hapus
  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final originalIndex = widget.user.taskManager
                  .getAllTasks()
                  .indexOf(task);

              try {
                await widget.storage.deleteTask(task);
                if (originalIndex >= 0) {
                  widget.user.taskManager.deleteTask(originalIndex);
                }
                navigator.pop();
                if (mounted) {
                  setState(() {});
                }
              } catch (_) {
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus tugas')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
