import 'package:chassis_sheet_app_v2/widgets/add_heading_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/checkpoint_model.dart';
import '../models/heading_model.dart';

class BottomActions extends StatelessWidget {
  final RxList<HeadingModel> headings;
  final RxList<CheckpointModel> checkpoints;
  final VoidCallback onSave;

  const BottomActions({
    super.key,
    required this.headings,
    required this.checkpoints,
    required this.onSave,
  });

  void _showAddHeadingDialog() {
    Get.dialog(AddHeadingDialog(
      onAdd: (String title) {
        final heading = HeadingModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          order: headings.length,
        );
        headings.add(heading);
      },
    ));
  }

 void _addNewCheckpoint() {
    if (headings.isEmpty) return;

    try {
      final lastHeading = headings.last;
      final newCheckpoint = CheckpointModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        headingId: lastHeading.id, // Make sure this matches exactly
        checkpoint: '',
        observationMethod: '',
        keyPoint: '',
        observation: '',
        actionForCorrection: '',
        remark: '',
        isImageType: false,
      );

      print('Adding checkpoint with headingId: ${lastHeading.id}'); // Debug log
      checkpoints.add(newCheckpoint);
      checkpoints.refresh();
    } catch (e) {
      print('Error adding checkpoint: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      onPressed: headings.isEmpty ? null : _addNewCheckpoint,
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
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Save Template'),
            ),
          ),
        ],
      ),
    );
  }
}
