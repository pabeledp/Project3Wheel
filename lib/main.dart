import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/glass_theme.dart';
import 'core/network/connectivity_service.dart';
import 'services/storage/hive_service.dart';
import 'services/sync/sync_engine.dart';
import 'services/mock/mock_data_seeder.dart';
import 'screens/main_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive dark system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Local Hive Storage
  final hive = HiveService();
  await hive.initialize();

  // Seed Realistic Fleet Mock Data on first run
  await MockDataSeeder.seedIfEmpty();

  // Initialize Real-time Network Watcher & Sync Engine
  await ConnectivityService().initialize();
  SyncEngine().initialize();

  // Initialize Firebase with DefaultFirebaseOptions and graceful offline fallback
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase Core initialized successfully with project3wheels.');
  } catch (e) {
    debugPrint('Firebase initialization notice: Running with local Hive persistence ($e)');
  }

  runApp(
    const ProviderScope(
      child: Project3WheelApp(),
    ),
  );
}

class Project3WheelApp extends StatelessWidget {
  const Project3WheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project 3 Wheel - Liquid Glass Fleet Hub',
      debugShowCheckedModeBanner: false,
      theme: GlassTheme.darkTheme,
      home: const MainShellScreen(),
    );
  }
}
