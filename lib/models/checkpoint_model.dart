class CheckpointModel {
  final String id;
  final String headingId; // Reference to parent heading
  final String checkpoint;
  final String observationMethod;
  final String keyPoint;
  final String observation;
  final String actionForCorrection;
  final String remark;
  final bool isImageType;
  final String? imagePath; // Store path to the image
  final bool isLocalImage;

  CheckpointModel({
    required this.id,
    required this.headingId,
    this.checkpoint = '',
    this.observationMethod = '',
    this.keyPoint = '',
    this.observation = '',
    this.actionForCorrection = '',
    this.remark = '',
    this.isImageType = false,
    this.imagePath,
    this.isLocalImage = false,
  });

  CheckpointModel copyWith({
    String? checkpoint,
    String? observationMethod,
    String? keyPoint,
    String? observation,
    String? actionForCorrection,
    String? remark,
    bool? isImageType,
    String? imagePath,
    bool? isLocalImage,
  }) =>
      CheckpointModel(
        id: id,
        headingId: headingId,
        checkpoint: checkpoint ?? this.checkpoint,
        observationMethod: observationMethod ?? this.observationMethod,
        keyPoint: keyPoint ?? this.keyPoint,
        observation: observation ?? this.observation,
        actionForCorrection: actionForCorrection ?? this.actionForCorrection,
        remark: remark ?? this.remark,
        isImageType: isImageType ?? this.isImageType,
        imagePath: imagePath ?? this.imagePath,
        isLocalImage: isLocalImage ?? this.isLocalImage,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'headingId': headingId,
        'checkpoint': checkpoint,
        'observationMethod': observationMethod,
        'keyPoint': keyPoint,
        'observation': observation,
        'actionForCorrection': actionForCorrection,
        'remark': remark,
        'isImageType': isImageType,
        'imagePath': imagePath,
      };

  factory CheckpointModel.fromJson(Map<String, dynamic> json) =>
      CheckpointModel(
        id: json['id'],
        headingId: json['headingId'],
        checkpoint: json['checkpoint'] ?? '',
        observationMethod: json['observationMethod'] ?? '',
        keyPoint: json['keyPoint'] ?? '',
        observation: json['observation'] ?? '',
        actionForCorrection: json['actionForCorrection'] ?? '',
        remark: json['remark'] ?? '',
        isImageType: json['isImageType'] ?? false,
        imagePath: json['imagePath'],
      );
}
