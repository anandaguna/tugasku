import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/task_storage.dart';

/// Halaman setting aplikasi.
class SettingsScreen extends StatelessWidget {
  final User user;
  final TaskStorage storage;

  const SettingsScreen({super.key, required this.user, required this.storage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info Aplikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _InfoRow(label: 'Nama Aplikasi', value: 'Tugasku'),
                  _InfoRow(label: 'Developer', value: 'Gusnan'),
                  _InfoRow(
                    label: 'Project',
                    value: 'UAS Pemrograman Berorientasi Objek',
                  ),
                  _InfoRow(label: 'Dibuat dengan', value: 'Flutter dan SQLite'),
                  _InfoRow(
                    label: 'Keterangan',
                    value:
                        'Aplikasi To-Do List berbasis Flutter dengan penerapan konsep Object Oriented Programming.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showResetConfirmation(context),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Data?'),
        content: const Text(
          'Semua data tugas akan dihapus dari database SQLite. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final messenger = ScaffoldMessenger.of(context);

              try {
                await storage.deleteTasks();
                user.taskManager.deleteAllTasks();
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Data tugas berhasil direset')),
                );
              } catch (_) {
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Gagal mereset data tugas')),
                );
              }
            },
            child: const Text('Ya, Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
