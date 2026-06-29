import 'package:flutter/material.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'services/task_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugasku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen untuk menampilkan informasi aplikasi sebelum masuk ke home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late User _user;
  final TaskStorage _storage = TaskStorage();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Inisialisasi aplikasi
  /// Membuat user baru dan memuat tasks dari storage
  void _initializeApp() {
    _user = User(name: 'Pengguna');

    // Load tasks dari SQLite storage
    Future.delayed(const Duration(seconds: 2), () async {
      // Muat tasks yang sudah disimpan
      final tasks = await _storage.loadTasks();
      for (var task in tasks) {
        _user.taskManager.addTask(task);
      }

      // Navigasi ke Home Screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: _user, storage: _storage),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[300]!, Colors.blue[700]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.checklist, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Tugasku',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aplikasi To-Do List Sederhana',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mempersiapkan aplikasi...',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
