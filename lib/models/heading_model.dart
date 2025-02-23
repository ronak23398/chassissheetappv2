class HeadingModel {
  final String id;
  final String title;
  final int order; // Add order field to maintain sequence

  HeadingModel({
    required this.id,
    required this.title,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'order': order,
      };

  factory HeadingModel.fromJson(Map<String, dynamic> json) => HeadingModel(
        id: json['id'],
        title: json['title'],
        order: json['order'] ?? 0,
      );
}
