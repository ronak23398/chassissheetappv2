import 'package:chassis_sheet_app_v2/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Fill New QC Form'),
              onPressed: () {
                // Navigate to form selection screen
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View Previous Submissions'),
              onPressed: () {
                // Navigate to submissions history screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
