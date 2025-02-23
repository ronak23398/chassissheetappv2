class HeadingModel {
  final String id;
  final String title;
  final List<String> checkpointIds; // Store IDs of associated checkpoints

  HeadingModel({
    required this.id,
    required this.title,
    this.checkpointIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'checkpointIds': checkpointIds,
      };

  factory HeadingModel.fromJson(Map<String, dynamic> json) => HeadingModel(
        id: json['id'],
        title: json['title'],
        checkpointIds: List<String>.from(json['checkpointIds'] ?? []),
      );
}
