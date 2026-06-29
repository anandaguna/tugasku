import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/priority_task.dart';
import '../services/task_storage.dart';

/// Halaman untuk menambahkan atau mengedit tugas
class AddEditTaskScreen extends StatefulWidget {
  final User user;
  final int? taskIndex;
  final TaskStorage storage;

  const AddEditTaskScreen({
    super.key,
    required this.user,
    this.taskIndex,
    required this.storage,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Priority _selectedPriority = Priority.medium;
  bool _isPriorityTask = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    // Jika edit mode, isi form dengan data tugas yang ada
    if (widget.taskIndex != null) {
      Task? task = widget.user.taskManager.getTaskByIndex(widget.taskIndex!);
      if (task != null) {
        _titleController.text = task.title;
        _descriptionController.text = task.description;

        if (task is PriorityTask) {
          _isPriorityTask = true;
          _selectedPriority = task.priority;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.taskIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Tugas' : 'Tambah Tugas'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Judul
              Text(
                'Judul Tugas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              // Input Deskripsi
              Text(
                'Deskripsi Tugas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Toggle untuk Priority Task
              Card(
                elevation: 0,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambahkan Prioritas?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: _isPriorityTask,
                        onChanged: (value) {
                          setState(() {
                            _isPriorityTask = value;
                          });
                        },
                        activeThumbColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pilihan Prioritas (hanya jika _isPriorityTask = true)
              if (_isPriorityTask)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Prioritas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildPriorityOptions(),
                    const SizedBox(height: 16),
                  ],
                ),

              // Tombol Aksi
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Batal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveTask,
                      icon: const Icon(Icons.save),
                      label: Text(isEditMode ? 'Update' : 'Simpan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk pilihan prioritas
  Widget _buildPriorityOptions() {
    return Column(
      children: Priority.values.map((priority) {
        String label = '';
        IconData icon = Icons.flag;
        Color color = Colors.grey;

        switch (priority) {
          case Priority.low:
            label = 'Rendah';
            color = Colors.green;
            icon = Icons.flag_outlined;
            break;
          case Priority.medium:
            label = 'Sedang';
            color = Colors.orange;
            icon = Icons.flag;
            break;
          case Priority.high:
            label = 'Tinggi';
            color = Colors.red;
            icon = Icons.flag;
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 0,
            color: _selectedPriority == priority
                ? color.withValues(alpha: 0.1)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: _selectedPriority == priority
                    ? color
                    : Colors.grey[300]!,
                width: _selectedPriority == priority ? 2 : 1,
              ),
            ),
            child: RadioListTile<Priority>(
              title: Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
              value: priority,
              selected: _selectedPriority == priority,
              // ignore: deprecated_member_use
              onChanged: (_) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
              activeColor: color,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Menyimpan atau mengupdate tugas
  Future<void> _saveTask() async {
    // Validasi input
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tugas tidak boleh kosong')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi tugas tidak boleh kosong')),
      );
      return;
    }

    final existingTask = widget.taskIndex != null
        ? widget.user.taskManager.getTaskByIndex(widget.taskIndex!)
        : null;

    // Membuat task baru
    Task newTask;
    if (_isPriorityTask) {
      newTask = PriorityTask(
        id: existingTask?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _selectedPriority,
        isCompleted: existingTask?.isCompleted ?? false,
        createdAt: existingTask?.createdAt,
      );
    } else {
      newTask = Task(
        id: existingTask?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: existingTask?.isCompleted ?? false,
        createdAt: existingTask?.createdAt,
      );
    }

    try {
      // Menambah atau mengupdate tugas
      if (widget.taskIndex != null) {
        // Edit mode
        await widget.storage.updateTask(newTask);
        widget.user.taskManager.updateTask(widget.taskIndex!, newTask);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil diupdate')),
        );
      } else {
        // Add mode
        await widget.storage.insertTask(newTask);
        widget.user.taskManager.addTask(newTask);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil ditambahkan')),
        );
      }

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan tugas')));
    }
  }
}
