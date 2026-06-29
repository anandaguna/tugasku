import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/priority_task.dart';

/// Halaman untuk menampilkan detail tugas
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    bool isPriorityTask = task is PriorityTask;
    PriorityTask? priorityTask = isPriorityTask ? task as PriorityTask : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      task.isCompleted ? 'Selesai' : 'Belum Selesai',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (isPriorityTask && priorityTask != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(int.parse(priorityTask.getPriorityColor().replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Prioritas: ${priorityTask.getPriorityString()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Judul
              Text(
                'Judul',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Deskripsi
              Text(
                'Deskripsi',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),

              // Info Tambahan
              _buildInfoCard(
                icon: Icons.info_outline,
                label: 'Informasi Lengkap',
                content: task.getTaskInfo(),
              ),
              const SizedBox(height: 24),

              // Tombol Kembali
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan kartu informasi
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
