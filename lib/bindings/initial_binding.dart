import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/auth_controller.dart';
import '../controller/manager_controller.dart';
import '../services/storage_supabase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Only register these if they haven't been registered yet
    if (!Get.isRegistered<SupabaseClient>()) {
      Get.put<SupabaseClient>(Supabase.instance.client);
    }

    if (!Get.isRegistered<DatabaseReference>()) {
      Get.put<DatabaseReference>(FirebaseDatabase.instance.ref());
    }

    // Register StorageService if not already registered
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(
        supabaseClient: Get.find<SupabaseClient>(),
        dbRef: Get.find<DatabaseReference>(),
      ));
    }

    // Register controllers
    Get.put(AuthController(), permanent: true);

    // Update ManagerController registration to use StorageService
    if (!Get.isRegistered<ManagerController>()) {
      Get.put(
          ManagerController(
            storageService: Get.find<StorageService>(),
          ),
          permanent: true);
    }
  }
}
