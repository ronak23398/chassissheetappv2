import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';

class CheckpointCard extends StatelessWidget {
  final CheckpointModel checkpoint;
  final VoidCallback onDelete;
  final Function(CheckpointModel) onUpdate;
  final VoidCallback? onImageTap;
  final VoidCallback onImagePickerTap;
  final int checkpointNumber; // Added checkpoint number

  const CheckpointCard({
    super.key,
    required this.checkpoint,
    required this.onDelete,
    required this.onUpdate,
    this.onImageTap,
    required this.onImagePickerTap,
    required this.checkpointNumber, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Checkpoint $checkpointNumber', // Updated to use checkpoint number
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text('Image Type'),
                    Switch(
                      value: checkpoint.isImageType,
                      onChanged: (value) {
                        final updated = checkpoint.copyWith(
                          isImageType: value,
                          imagePath: value ? checkpoint.imagePath : null,
                        );
                        onUpdate(updated);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image section when isImageType is true
            if (checkpoint.isImageType) ...[
              if (checkpoint.imagePath != null)
                GestureDetector(
                  onTap: onImageTap,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(checkpoint.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: onImagePickerTap,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 48),
                        SizedBox(height: 8),
                        Text('Add Image'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],

            _buildTextField(
              label:
                  checkpoint.isImageType ? 'Image Description' : 'Checkpoint',
              value: checkpoint.checkpoint,
              onChanged: (value) => _updateCheckpoint(checkpoint: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Observation Method',
              value: checkpoint.observationMethod,
              onChanged: (value) => _updateCheckpoint(observationMethod: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Key Point',
              value: checkpoint.keyPoint,
              onChanged: (value) => _updateCheckpoint(keyPoint: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Observation',
              value: checkpoint.observation,
              onChanged: (value) => _updateCheckpoint(observation: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Action for Correction',
              value: checkpoint.actionForCorrection,
              onChanged: (value) =>
                  _updateCheckpoint(actionForCorrection: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Remark',
              value: checkpoint.remark,
              onChanged: (value) => _updateCheckpoint(remark: value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      onChanged: onChanged,
    );
  }

  void _updateCheckpoint({
    String? checkpoint,
    String? observationMethod,
    String? keyPoint,
    String? observation,
    String? actionForCorrection,
    String? remark,
  }) {
    final updated = this.checkpoint.copyWith(
          checkpoint: checkpoint,
          observationMethod: observationMethod,
          keyPoint: keyPoint,
          observation: observation,
          actionForCorrection: actionForCorrection,
          remark: remark,
        );
    onUpdate(updated);
  }
}
