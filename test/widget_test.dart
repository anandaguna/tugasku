import 'package:flutter_test/flutter_test.dart';
import 'package:tugasku/models/priority_task.dart';
import 'package:tugasku/models/task.dart';

void main() {
  test('Task bisa dikonversi ke Map dan kembali dari Map', () {
    final task = Task(
      id: 1,
      title: 'Belajar SQLite',
      description: 'Mengubah penyimpanan lokal menjadi database',
      isCompleted: true,
      createdAt: DateTime.parse('2026-06-18T10:00:00.000'),
    );

    final map = task.toMap();
    final restoredTask = Task.fromMap(map);

    expect(restoredTask.id, 1);
    expect(restoredTask.title, 'Belajar SQLite');
    expect(
      restoredTask.description,
      'Mengubah penyimpanan lokal menjadi database',
    );
    expect(restoredTask.isCompleted, isTrue);
    expect(map['isPriority'], 0);
  });

  test('PriorityTask menyimpan prioritas ke Map dan memuatnya kembali', () {
    final task = PriorityTask(
      id: 2,
      title: 'Presentasi UAS',
      description: 'Menyiapkan demo aplikasi Tugasku',
      priority: Priority.high,
      createdAt: DateTime.parse('2026-06-18T11:00:00.000'),
    );

    final map = task.toMap();
    final restoredTask = PriorityTask.fromMap(map);

    expect(restoredTask.id, 2);
    expect(restoredTask.title, 'Presentasi UAS');
    expect(restoredTask.priority, Priority.high);
    expect(restoredTask.getPriorityString(), 'Tinggi');
    expect(map['isPriority'], 1);
    expect(map['priority'], 'high');
  });
}
