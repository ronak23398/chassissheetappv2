import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String> getUserRole(String uid) async {
    try {
      print('Fetching role for user: $uid');
      final snapshot =
          await _database.child('users').child(uid).child('role').get();
      print('Database snapshot: ${snapshot.value}');
      if (snapshot.exists) {
        return snapshot.value.toString();
      }
      print('No role found, defaulting to worker');
      return 'worker'; // Default role
    } catch (e) {
      print('Error getting user role: $e');
      return 'worker'; // Default role on error
    }
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _database.child('users').child(uid).set(userData);
  }
}
