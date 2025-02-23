import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

class StorageService {
  final SupabaseClient _supabaseClient;
  final DatabaseReference _dbRef;

  StorageService({
    required SupabaseClient supabaseClient,
    required DatabaseReference dbRef,
  })  : _supabaseClient = supabaseClient,
        _dbRef = dbRef;

  Future<String?> processCheckpointImage(
      String checkpointId, String localImagePath) async {
    try {
      final imageFile = File(localImagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'checkpoints/$checkpointId/$timestamp.jpg';

      // Upload to Supabase
      await _supabaseClient.storage
          .from('chassis-images')
          .upload(path, imageFile);

      // Get public URL
      final imageUrl =
          _supabaseClient.storage.from('chassis-images').getPublicUrl(path);

      // Save URL to Firebase

      return imageUrl;
    } catch (e) {
      print('Error processing image: $e');
      rethrow; // Propagate error to handle it in the controller
    }
  }

  Future<void> deleteImage(String checkpointId, String imagePath) async {
    try {
      // Extract path from URL
      final uri = Uri.parse(imagePath);
      final pathSegments = uri.pathSegments;
      final pathToDelete = pathSegments
          .skipWhile((segment) => segment != 'checkpoints')
          .join('/');

      // Delete from Supabase
      await _supabaseClient.storage
          .from('chassis-images')
          .remove([pathToDelete]);

      // Remove from Firebase
      await _dbRef.child('checkpoint_images').child(checkpointId).remove();
    } catch (e) {
      print('Error deleting image: $e');
      throw Exception('Failed to delete image: $e');
    }
  }
}
