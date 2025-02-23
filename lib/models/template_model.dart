import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';
import 'package:chassis_sheet_app_v2/models/heading_model.dart';

class TemplateModel {
  final String id;
  String machinePartName;
  String machinePartId;
  List<CheckpointModel> checkpoints;
  List<HeadingModel> headings;
  DateTime createdAt;
  DateTime updatedAt;

  TemplateModel({
    required this.id,
    required this.machinePartName,
    required this.machinePartId,
    required this.checkpoints,
    required this.headings,
    required this.createdAt,
    required this.updatedAt,
  });

  TemplateModel copyWith({
    String? id,
    String? machinePartName,
    String? machinePartId,
    List<CheckpointModel>? checkpoints,
    List<HeadingModel>? headings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      machinePartName: machinePartName ?? this.machinePartName,
      machinePartId: machinePartId ?? this.machinePartId,
      checkpoints: checkpoints ?? this.checkpoints,
      headings: headings ?? this.headings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'machinePartName': machinePartName,
        'machinePartId': machinePartId,
        'checkpoints': checkpoints.map((cp) => cp.toJson()).toList(),
        'headings': headings.map((h) => h.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
        id: json['id'],
        machinePartName: json['machinePartName'],
        machinePartId: json['machinePartId'],
        checkpoints: (json['checkpoints'] as List)
            .map((cp) => CheckpointModel.fromJson(cp))
            .toList(),
        headings: (json['headings'] as List)
            .map((h) => HeadingModel.fromJson(h))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  List<Map<String, dynamic>> toExcelRows() {
    List<Map<String, dynamic>> rows = [];

    for (var heading in headings) {
      rows.add({
        'Section': heading.title,
        'Checkpoint': '',
        'Observation Method': '',
        'Key Point': '',
        'Observation': '',
        'Action for Correction': '',
        'Remark': '',
      });

      final headingCheckpoints =
          checkpoints.where((cp) => cp.headingId == heading.id).toList();

      for (var checkpoint in headingCheckpoints) {
        rows.add({
          'Section': '',
          'Checkpoint': checkpoint.checkpoint,
          'Observation Method': checkpoint.observationMethod,
          'Key Point': checkpoint.keyPoint,
          'Observation': checkpoint.observation,
          'Action for Correction': checkpoint.actionForCorrection,
          'Remark': checkpoint.remark,
        });
      }
    }

    return rows;
  }
}
