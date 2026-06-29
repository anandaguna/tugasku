# Tugasku

Tugasku is a Flutter to-do list application created for an Object-Oriented Programming (OOP) project. The app helps users manage daily tasks with CRUD features, priority levels, completion status, simple statistics, and local SQLite storage.

---

## Bahasa Indonesia

### Deskripsi

Tugasku adalah aplikasi To-Do List sederhana berbasis Flutter. Aplikasi ini dibuat sebagai project Pemrograman Berorientasi Objek (PBO) dengan penerapan konsep class, object, encapsulation, inheritance, polymorphism, dan method overriding.

### Fitur

- Menambahkan tugas baru.
- Mengedit judul, deskripsi, dan prioritas tugas.
- Menghapus tugas.
- Menandai tugas sebagai selesai atau belum selesai.
- Menampilkan detail tugas.
- Menampilkan statistik jumlah tugas total, selesai, dan belum selesai.
- Mengurutkan tugas berdasarkan prioritas.
- Menyimpan data tugas secara lokal menggunakan SQLite.
- Reset semua data tugas melalui halaman Settings.

### Teknologi

- Flutter
- Dart
- SQLite melalui package `sqflite`
- Material Design

### Konsep OOP yang Digunakan

- `Task` sebagai base class untuk data tugas umum.
- `PriorityTask` sebagai subclass dari `Task`.
- Encapsulation melalui private attribute dan getter/setter.
- Inheritance melalui `PriorityTask extends Task`.
- Polymorphism karena `PriorityTask` tetap dapat diperlakukan sebagai `Task`.
- Method overriding pada method `getTaskInfo()`.
- Enum `Priority` untuk pilihan prioritas rendah, sedang, dan tinggi.

### Struktur Folder Utama

```text
lib/
  main.dart
  models/
    task.dart
    priority_task.dart
    task_manager.dart
    user.dart
  screens/
    home_screen.dart
    add_edit_task_screen.dart
    task_detail_screen.dart
    settings_screen.dart
  services/
    task_storage.dart
test/
  widget_test.dart
```

### Persyaratan

Pastikan sudah menginstall:

- Flutter SDK
- Dart SDK yang kompatibel dengan project
- Android Studio atau VS Code
- Android Emulator atau perangkat Android
- Git

Cek instalasi Flutter:

```bash
flutter doctor
```

### Cara Menjalankan Project

1. Clone repository:

```bash
git clone https://github.com/anandaguna/tugasku.git
```

2. Masuk ke folder project:

```bash
cd tugasku
```

3. Install dependency:

```bash
flutter pub get
```

4. Jalankan aplikasi:

```bash
flutter run
```

Jika ingin memilih device tertentu:

```bash
flutter devices
flutter run -d <device_id>
```

### Download APK

File APK release tersedia di root repository:

```text
Tugasku-release.apk
```

Jika membuka repository melalui GitHub, pilih file `Tugasku-release.apk`, lalu klik tombol download untuk menyimpan APK ke perangkat.

### Cara Build APK

Untuk membuat file APK release:

```bash
flutter build apk --release
```

Hasil build biasanya berada di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

### Cara Menjalankan Test

```bash
flutter test
```

### Cara Menggunakan Aplikasi

1. Buka aplikasi Tugasku.
2. Tekan tombol `+` untuk menambahkan tugas.
3. Isi judul dan deskripsi tugas.
4. Aktifkan pilihan prioritas jika tugas memiliki tingkat kepentingan tertentu.
5. Simpan tugas.
6. Centang tugas jika sudah selesai.
7. Gunakan menu pada setiap tugas untuk melihat detail, mengedit, atau menghapus tugas.
8. Buka halaman Settings untuk melihat info aplikasi atau mereset semua data.

---

## English

### Description

Tugasku is a simple Flutter-based To-Do List application. It was built as an Object-Oriented Programming (OOP) project and demonstrates class, object, encapsulation, inheritance, polymorphism, and method overriding concepts.

### Features

- Add new tasks.
- Edit task title, description, and priority.
- Delete tasks.
- Mark tasks as completed or not completed.
- View task details.
- Show task statistics: total, completed, and uncompleted.
- Sort tasks by priority.
- Store task data locally using SQLite.
- Reset all task data from the Settings page.

### Technologies

- Flutter
- Dart
- SQLite through the `sqflite` package
- Material Design

### OOP Concepts Used

- `Task` as the base class for common task data.
- `PriorityTask` as a subclass of `Task`.
- Encapsulation through private attributes and getter/setter methods.
- Inheritance through `PriorityTask extends Task`.
- Polymorphism because `PriorityTask` can still be handled as a `Task`.
- Method overriding in the `getTaskInfo()` method.
- `Priority` enum for low, medium, and high priority levels.

### Main Folder Structure

```text
lib/
  main.dart
  models/
    task.dart
    priority_task.dart
    task_manager.dart
    user.dart
  screens/
    home_screen.dart
    add_edit_task_screen.dart
    task_detail_screen.dart
    settings_screen.dart
  services/
    task_storage.dart
test/
  widget_test.dart
```

### Requirements

Make sure you have installed:

- Flutter SDK
- Dart SDK compatible with this project
- Android Studio or VS Code
- Android Emulator or Android device
- Git

Check your Flutter installation:

```bash
flutter doctor
```

### How to Run the Project

1. Clone the repository:

```bash
git clone https://github.com/anandaguna/tugasku.git
```

2. Open the project folder:

```bash
cd tugasku
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

To select a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

### Download APK

The release APK file is available in the repository root:

```text
Tugasku-release.apk
```

When opening the repository on GitHub, select the `Tugasku-release.apk` file, then click the download button to save the APK to your device.

### How to Build APK

To create a release APK:

```bash
flutter build apk --release
```

The build output is usually located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

### How to Run Tests

```bash
flutter test
```

### How to Use the App

1. Open the Tugasku app.
2. Press the `+` button to add a task.
3. Fill in the task title and description.
4. Enable priority if the task has a specific importance level.
5. Save the task.
6. Check a task when it is completed.
7. Use the menu on each task to view details, edit, or delete it.
8. Open Settings to view app information or reset all task data.

---

## Author

Developed by Gusnan for an Object-Oriented Programming project.
