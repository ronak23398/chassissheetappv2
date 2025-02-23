import 'dart:io';
import 'package:chassis_sheet_app_v2/controller/manager_controller.dart';
import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:chassis_sheet_app_v2/models/heading_model.dart';
import 'package:chassis_sheet_app_v2/models/template_model.dart';
import 'package:chassis_sheet_app_v2/widgets/checkpoint_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker/image_picker.dart';

class CreateTemplateScreen extends StatefulWidget {
  final TemplateModel? template;

  const CreateTemplateScreen({super.key, this.template});

  @override
  CreateTemplateScreenState createState() => CreateTemplateScreenState();
}

class CreateTemplateScreenState extends State<CreateTemplateScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController machinePartNameController;
  late TextEditingController machinePartIdController;
  late TextEditingController HeadingNameController;
  final RxList<CheckpointModel> checkpoints = <CheckpointModel>[].obs;
  final RxList<HeadingModel> headings = <HeadingModel>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    machinePartNameController = TextEditingController(
      text: widget.template?.machinePartName ?? '',
    );
    machinePartIdController = TextEditingController(
      text: widget.template?.machinePartId ?? '',
    );
    HeadingNameController = TextEditingController();
    if (widget.template != null) {
      checkpoints.addAll(widget.template!.checkpoints);
      headings.addAll(
        widget.template!.sections.map((title) => HeadingModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
            )),
      );
    }
  }

  // Get checkpoint number for a specific section
  int getCheckpointNumber(String headingId, CheckpointModel checkpoint) {
    final sectionCheckpoints =
        checkpoints.where((cp) => cp.headingId == headingId).toList();
    return sectionCheckpoints.indexOf(checkpoint) + 1;
  }

  void _addHeading() {
    if (HeadingNameController.text.isNotEmpty) {
      final heading = HeadingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: HeadingNameController.text,
      );
      headings.add(heading);
      HeadingNameController.clear();
      Get.back();
    }
  }

  void _showAddHeadingDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Add Heading'),
        content: TextField(
          controller: HeadingNameController,
          decoration: const InputDecoration(
            labelText: 'Heading Name',
            hintText: 'Enter heading name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addHeading,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(CheckpointModel checkpoint) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final index = checkpoints.indexOf(checkpoint);
                  checkpoints[index] = checkpoint.copyWith(
                    imagePath: image.path,
                    isImageType: true,
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  final index = checkpoints.indexOf(checkpoint);
                  checkpoints[index] = checkpoint.copyWith(
                    imagePath: image.path,
                    isImageType: true,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imagePath) {
    Get.dialog(
      Dialog.fullscreen(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: FileImage(File(imagePath)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              enableRotation: false,
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
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
                // Machine Part Details Heading
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Machine Part Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: machinePartNameController,
                          decoration: const InputDecoration(
                            labelText: 'Machine Part Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: machinePartIdController,
                          decoration: const InputDecoration(
                            labelText: 'Machine Part ID',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sections and Checkpoints
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: headings.length,
                    itemBuilder: (context, index) {
                      final heading = headings[index];
                      final sectionCheckpoints = checkpoints
                          .where((cp) => cp.headingId == heading.id)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Heading Header
                          Card(
                            child: ListTile(
                              title: Text(
                                'Heading ${String.fromCharCode(65 + index)}: ${heading.title}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Remove heading and its checkpoints
                                  headings.removeAt(index);
                                  checkpoints.removeWhere(
                                    (checkpoint) =>
                                        checkpoint.headingId == heading.id,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Checkpoints for this section
                          ...sectionCheckpoints.map((checkpoint) =>
                              CheckpointCard(
                                checkpoint: checkpoint,
                                onDelete: () => checkpoints.remove(checkpoint),
                                onUpdate: (CheckpointModel updated) {
                                  final index = checkpoints.indexOf(checkpoint);
                                  checkpoints[index] = updated;
                                },
                                onImageTap: checkpoint.imagePath != null
                                    ? () => _showFullScreenImage(
                                        checkpoint.imagePath!)
                                    : null,
                                onImagePickerTap: () =>
                                    _showImagePickerDialog(checkpoint),
                                checkpointNumber:
                                    getCheckpointNumber(heading.id, checkpoint),
                              )),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          // Fixed bottom buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAddHeadingDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Heading'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() => ElevatedButton.icon(
                              onPressed: headings.isEmpty
                                  ? null
                                  : () {
                                      final newCheckpoint = CheckpointModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        headingId: headings.last.id,
                                        checkpoint: '',
                                        observationMethod: '',
                                        keyPoint: '',
                                        observation: '',
                                        actionForCorrection: '',
                                        remark: '',
                                        isImageType: false,
                                      );
                                      checkpoints.add(newCheckpoint);
                                    },
                              icon: const Icon(Icons.add_box),
                              label: const Text('Add Checkpoint'),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final template = TemplateModel(
                            id: widget.template?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            machinePartName: machinePartNameController.text,
                            machinePartId: machinePartIdController.text,
                            checkpoints: checkpoints,
                            sections: headings.map((h) => h.title).toList(),
                            createdAt:
                                widget.template?.createdAt ?? DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          controller.saveTemplate(template);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Save Template'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
