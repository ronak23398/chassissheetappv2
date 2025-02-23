import 'dart:io';
import 'package:chassis_sheet_app_v2/services/storage_supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckpointCard extends StatelessWidget {
  final CheckpointModel checkpoint;
  final VoidCallback onDelete;
  final Function(CheckpointModel) onUpdate;
  final int checkpointNumber;
  final StorageService storageService;

  const CheckpointCard({
    super.key,
    required this.checkpoint,
    required this.onDelete,
    required this.onUpdate,
    required this.checkpointNumber,
    required this.storageService,
  });

  Future<void> _handleImagePicker() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await showModalBottomSheet<XFile?>(
        context: Get.context!,
        builder: (BuildContext context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context,
                      await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context,
                      await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        ),
      );

      if (image != null) {
        // Just update the local path and mark as local image
        onUpdate(checkpoint.copyWith(
          imagePath: image.path,
          isImageType: true,
          isLocalImage: true, // Add this
        ));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleImageDelete() async {
    if (checkpoint.imagePath == null) return;

    try {
      await storageService.deleteImage(checkpoint.id, checkpoint.imagePath!);
      onUpdate(checkpoint.copyWith(
        imagePath: null,
        isImageType: false,
      ));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildImageSection() {
    if (!checkpoint.isImageType) return const SizedBox.shrink();

    if (checkpoint.imagePath != null) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(checkpoint.imagePath!),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: checkpoint.isLocalImage
                      ? Image.file(
                          File(checkpoint.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: checkpoint.imagePath!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error),
                          ),
                        )),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _handleImageDelete,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: _handleImagePicker,
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
    );
  }

  void _showFullScreenImage(String imagePath) {
    Get.dialog(
      Dialog.fullscreen(
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: imagePath.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      )
                    : Image.file(File(imagePath)),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Checkpoint $checkpointNumber',
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
                      onChanged: (value) async {
                        if (!value && checkpoint.imagePath != null) {
                          await _handleImageDelete();
                        }
                        final updated = checkpoint.copyWith(isImageType: value);
                        onUpdate(updated);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (checkpoint.imagePath != null) {
                          await _handleImageDelete();
                        }
                        onDelete();
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildImageSection(),
            if (checkpoint.isImageType) const SizedBox(height: 10),
            _buildFormFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          label: checkpoint.isImageType ? 'Image Description' : 'Checkpoint',
          value: checkpoint.checkpoint,
          onChanged: (value) => _updateCheckpoint(checkpoint: value),
          validator: (value) =>
              value?.isEmpty ?? true ? 'This field is required' : null,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Observation Method',
          value: checkpoint.observationMethod,
          onChanged: (value) => _updateCheckpoint(observationMethod: value),
        ),
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Key Point',
          value: checkpoint.keyPoint,
          onChanged: (value) => _updateCheckpoint(keyPoint: value),
        ),
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Observation',
          value: checkpoint.observation,
          onChanged: (value) => _updateCheckpoint(observation: value),
        ),
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Action for Correction',
          value: checkpoint.actionForCorrection,
          onChanged: (value) => _updateCheckpoint(actionForCorrection: value),
        ),
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Remark',
          value: checkpoint.remark,
          onChanged: (value) => _updateCheckpoint(remark: value),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines ?? 1,
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
