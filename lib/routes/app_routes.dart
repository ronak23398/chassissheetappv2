import 'package:chassis_sheet_app_v2/screens/auth/login_screen.dart';
import 'package:chassis_sheet_app_v2/screens/auth/signup_screen.dart';
import 'package:chassis_sheet_app_v2/screens/manager/manager_dashboard.dart';
import 'package:chassis_sheet_app_v2/screens/splash_screen.dart';
import 'package:chassis_sheet_app_v2/screens/worker/worker_dashboard.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String managerDashboard = '/manager-dashboard';
  static const String workerDashboard = '/worker-dashboard';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: managerDashboard, page: () => const ManagerDashboard()),
    GetPage(name: workerDashboard, page: () => const WorkerDashboard()),
  ];
}
