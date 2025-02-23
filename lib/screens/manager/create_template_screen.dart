import 'package:chassis_sheet_app_v2/controller/manager_controller.dart';
import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:chassis_sheet_app_v2/models/heading_model.dart';
import 'package:chassis_sheet_app_v2/models/template_model.dart';
import 'package:chassis_sheet_app_v2/services/storage_supabase_service.dart';
import 'package:chassis_sheet_app_v2/widgets/bottom_actions.dart';
import 'package:chassis_sheet_app_v2/widgets/heading_section.dart';
import 'package:chassis_sheet_app_v2/widgets/machine_part_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTemplateScreen extends StatefulWidget {
  final TemplateModel? template;
  const CreateTemplateScreen({super.key, this.template});

  @override
  CreateTemplateScreenState createState() => CreateTemplateScreenState();
}

class CreateTemplateScreenState extends State<CreateTemplateScreen> {
  late final StorageService storageService;
  final formKey = GlobalKey<FormState>();
  late TextEditingController machinePartNameController;
  late TextEditingController machinePartIdController;
  final RxList<CheckpointModel> checkpoints = <CheckpointModel>[].obs;
  final RxList<HeadingModel> headings = <HeadingModel>[].obs;

  @override
  void initState() {
    super.initState();
    storageService = StorageService(
      supabaseClient: Get.find(), // Ensure Supabase client is registered
      dbRef: Get.find(), // Ensure Firebase DatabaseReference is registered
    );
    machinePartNameController = TextEditingController(
      text: widget.template?.machinePartName ?? '',
    );
    machinePartIdController = TextEditingController(
      text: widget.template?.machinePartId ?? '',
    );
    if (widget.template != null) {
      checkpoints.addAll(widget.template!.checkpoints);
      headings.addAll(widget.template!.headings);
    }
  }

  @override
  void dispose() {
    machinePartNameController.dispose();
    machinePartIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ManagerController controller = Get.find<ManagerController>();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.template == null ? 'Create Template' : 'Edit Template'),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 140,
              ),
              children: [
                MachinePartForm(
                  nameController: machinePartNameController,
                  idController: machinePartIdController,
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: headings.length,
                    itemBuilder: (context, index) => HeadingSection(
                      heading: headings[index],
                      checkpoints: checkpoints,
                      onDeleteHeading: () => headings.removeAt(index),
                      onUpdateCheckpoint: (old, updated) {
                        try {
                          final index =
                              checkpoints.indexWhere((cp) => cp.id == old.id);
                          if (index != -1) {
                            checkpoints[index] = updated;
                            checkpoints.refresh(); // Force refresh
                          }
                        } catch (e) {
                          print('Error updating checkpoint: $e');
                        }
                      },
                      onDeleteCheckpoint: (checkpoint) {
                        checkpoints.remove(checkpoint);
                        checkpoints.refresh(); // Force refresh
                      },
                      sectionIndex: index,
                      storageService: storageService,
                    ),
                  );
                }),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomActions(
                headings: headings,
                checkpoints: checkpoints,
                onSave: () {
                  if (formKey.currentState!.validate()) {
                    final template = TemplateModel(
                      id: widget.template?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      machinePartName: machinePartNameController.text,
                      machinePartId: machinePartIdController.text,
                      checkpoints: checkpoints,
                      headings: headings,
                      createdAt: widget.template?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    controller.saveTemplate(template);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
