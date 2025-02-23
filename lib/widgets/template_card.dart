import 'package:chassis_sheet_app_v2/controller/manager_controller.dart';
import 'package:chassis_sheet_app_v2/models/template_model.dart';
import 'package:chassis_sheet_app_v2/screens/manager/create_template_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateCard extends StatelessWidget {
  final TemplateModel template;

  const TemplateCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(template.machinePartName),
        subtitle: Text('ID: ${template.machinePartId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Get.to(() => CreateTemplateScreen(
                    template: template,
                  )),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  Get.find<ManagerController>().deleteTemplate(template.id),
            ),
          ],
        ),
      ),
    );
  }
}
