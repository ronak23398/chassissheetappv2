import 'package:chassis_sheet_app_v2/controller/auth_controller.dart';
import 'package:chassis_sheet_app_v2/controller/manager_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  // lib/bindings/initial_binding.dart
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(ManagerController(), permanent: true);
  }
}
