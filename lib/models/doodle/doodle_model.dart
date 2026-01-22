class DoodleModel {
  final String id;
  final String title;
  final String authorId;
  final String authorName;
  final String? previewBase64;
  final String? fullImageBase64;

  const DoodleModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    this.previewBase64,
    this.fullImageBase64,
  });

  factory DoodleModel.fromJson(Map<String, dynamic> json) {
    return DoodleModel(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      authorId: (json['authorId'] ?? '') as String,
      authorName: (json['authorName'] ?? '') as String,
      previewBase64: json['previewBase64'] as String?,
      fullImageBase64: json['fullImageBase64'] as String?,
    );
  }
}
