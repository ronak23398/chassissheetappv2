import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:chassis_sheet_app_v2/services/storage_supabase_service.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/template_model.dart';

class ManagerController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final RxList<TemplateModel> templates = <TemplateModel>[].obs;
  final RxBool isLoading = false.obs;
  late final StorageService _storageService;

  ManagerController({required StorageService storageService}) {
    _storageService = storageService;
  }

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    try {
      isLoading.value = true;
      final snapshot = await _database.child('templates').get();
      if (snapshot.exists) {
        templates.value = (snapshot.value as Map)
            .values
            .map((e) => TemplateModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load templates');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTemplate(TemplateModel template) async {
    try {
      isLoading.value = true;

      // Process checkpoints with local images sequentially to ensure proper upload order
      final List<CheckpointModel> updatedCheckpoints = [];

      for (var checkpoint in template.checkpoints) {
        if (checkpoint.isLocalImage && checkpoint.imagePath != null) {
          try {
            final imageUrl = await _storageService.processCheckpointImage(
              checkpoint.id,
              checkpoint.imagePath!,
            );

            if (imageUrl != null) {
              updatedCheckpoints.add(checkpoint.copyWith(
                imagePath: imageUrl,
                isLocalImage: false,
              ));
            } else {
              // If image upload failed, keep the checkpoint as is
              updatedCheckpoints.add(checkpoint);
            }
          } catch (e) {
            print('Error processing image for checkpoint ${checkpoint.id}: $e');
            // Continue with other checkpoints even if one fails
            updatedCheckpoints.add(checkpoint);
          }
        } else {
          // For checkpoints without local images, add them as is
          updatedCheckpoints.add(checkpoint);
        }
      }

      // Create updated template with processed images
      final updatedTemplate = template.copyWith(
        checkpoints: updatedCheckpoints,
      );

      // Save template to Firebase
      await _database
          .child('templates')
          .child(updatedTemplate.id)
          .set(updatedTemplate.toJson());

      await loadTemplates();
      Get.back();
      Get.snackbar('Success', 'Template saved successfully');
    } catch (e) {
      print('Error saving template: $e');
      Get.snackbar('Error', 'Failed to save template');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTemplate(String templateId) async {
    try {
      isLoading.value = true;

      // Get template data first to handle image cleanup
      final snapshot =
          await _database.child('templates').child(templateId).get();
      if (snapshot.exists) {
        final template = TemplateModel.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map),
        );

        // Delete all associated images
        for (var checkpoint in template.checkpoints) {
          if (checkpoint.imagePath != null && !checkpoint.isLocalImage) {
            try {
              await _storageService.deleteImage(
                  checkpoint.id, checkpoint.imagePath!);
            } catch (e) {
              print('Error deleting image for checkpoint ${checkpoint.id}: $e');
              // Continue with other deletions even if one fails
            }
          }
        }
      }

      // Delete template data
      await _database.child('templates').child(templateId).remove();
      await loadTemplates();
      Get.snackbar('Success', 'Template deleted successfully');
    } catch (e) {
      print('Error deleting template: $e');
      Get.snackbar('Error', 'Failed to delete template');
    } finally {
      isLoading.value = false;
    }
  }
}
