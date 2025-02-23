import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  try {
    await Supabase.initialize(
      url: 'https://fdkjbirfhtxcbmuidwvc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZka2piaXJmaHR4Y2JtdWlkd3ZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzMDY1NzIsImV4cCI6MjA1NTg4MjU3Mn0.A4oDXlph0roltFWB0ra-5oMdHhCDBIeVBsxxYu2Yg8k',
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Machinery QC App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
