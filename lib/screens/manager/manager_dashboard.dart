import 'package:chassis_sheet_app_v2/controller/auth_controller.dart';
import 'package:chassis_sheet_app_v2/screens/manager/reports_screen.dart';
import 'package:chassis_sheet_app_v2/screens/manager/submission_screen.dart';
import 'package:chassis_sheet_app_v2/screens/manager/template_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Manager Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authController.signOut(),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Templates'),
                Tab(text: 'Submissions'),
                Tab(text: 'Reports'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TemplateScreen(),
              SubmissionsScreen(), // To be implemented
              ReportsScreen(), // To be implemented
            ],
          )),
    );
  }
}
