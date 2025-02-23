import 'package:chassis_sheet_app_v2/models/checkpoint_model.dart';

class TemplateModel {
  final String id;
  String machinePartName;
  String machinePartId;
  List<CheckpointModel> checkpoints;
  List<String> sections;
  DateTime createdAt;
  DateTime updatedAt;

  TemplateModel({
    required this.id,
    required this.machinePartName,
    required this.machinePartId,
    required this.checkpoints,
    required this.sections,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'machinePartName': machinePartName,
        'machinePartId': machinePartId,
        'checkpoints': checkpoints.map((cp) => cp.toJson()).toList(),
        'sections': sections,
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
        sections: List<String>.from(json['sections']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
