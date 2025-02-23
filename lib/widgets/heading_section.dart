import 'package:chassis_sheet_app_v2/services/storage_supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/heading_model.dart';
import '../models/checkpoint_model.dart';
import 'checkpoint_card.dart';

class HeadingSection extends StatelessWidget {
  final HeadingModel heading;
  final RxList<CheckpointModel> checkpoints;
  final VoidCallback onDeleteHeading;
  final Function(CheckpointModel, CheckpointModel) onUpdateCheckpoint;
  final Function(CheckpointModel) onDeleteCheckpoint;
  final int sectionIndex;
  final StorageService storageService;

  const HeadingSection({
    super.key,
    required this.heading,
    required this.checkpoints,
    required this.onDeleteHeading,
    required this.onUpdateCheckpoint,
    required this.onDeleteCheckpoint,
    required this.sectionIndex,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: ListTile(
            title: Text(
              'Heading ${String.fromCharCode(65 + sectionIndex)}: ${heading.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeleteHeading,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final sectionCheckpoints =
              checkpoints.where((cp) => cp.headingId == heading.id).toList();

          print(
              'Heading ${heading.id} has ${sectionCheckpoints.length} checkpoints'); // Debug print

          return Column(
            children: sectionCheckpoints.asMap().entries.map((entry) {
              final index = entry.key;
              final checkpoint = entry.value;
              return CheckpointCard(
                key: ValueKey(checkpoint
                    .id), // Add a key for better widget identification
                checkpoint: checkpoint,
                onDelete: () => onDeleteCheckpoint(checkpoint),
                onUpdate: (updated) => onUpdateCheckpoint(checkpoint, updated),
                checkpointNumber: index + 1,
                storageService: storageService,
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
