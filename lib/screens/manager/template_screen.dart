import 'package:chassis_sheet_app_v2/controller/manager_controller.dart';
import 'package:chassis_sheet_app_v2/screens/manager/create_template_screen.dart';
import 'package:chassis_sheet_app_v2/widgets/template_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ManagerController controller = Get.find<ManagerController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.templates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No templates yet'),
                ElevatedButton(
                  onPressed: () => Get.to(() => const CreateTemplateScreen()),
                  child: const Text('Create Template'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.templates.length,
          itemBuilder: (context, index) {
            final template = controller.templates[index];
            return TemplateCard(template: template);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateTemplateScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
