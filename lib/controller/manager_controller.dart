import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/template_model.dart';

class ManagerController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final RxList<TemplateModel> templates = <TemplateModel>[].obs;
  final RxBool isLoading = false.obs;

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
      await _database
          .child('templates')
          .child(template.id)
          .set(template.toJson());
      await loadTemplates();
      Get.back();
      Get.snackbar('Success', 'Template saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save template');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTemplate(String templateId) async {
    try {
      isLoading.value = true;
      await _database.child('templates').child(templateId).remove();
      await loadTemplates();
      Get.snackbar('Success', 'Template deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete template');
    } finally {
      isLoading.value = false;
    }
  }
}
