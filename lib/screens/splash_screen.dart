import 'package:chassis_sheet_app_v2/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    // Add a slight delay to ensure Firebase is initialized
    Future.delayed(const Duration(seconds: 2), () {
      checkAuthState();
    });
  }

  Future<void> checkAuthState() async {
    try {
      final currentUser = authController.user.value;
      if (currentUser != null) {
        final userRole = await firebaseService.getUserRole(currentUser.uid);
        Get.offAllNamed(
          userRole == 'manager'
              ? AppRoutes.managerDashboard
              : AppRoutes.workerDashboard,
        );
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      print('Error in checkAuthState: $e');
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FlutterLogo(size: 100),
            SizedBox(height: 24),
            Text(
              'Machinery QC App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
