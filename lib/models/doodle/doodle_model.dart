class DoodleModel {
  final String id;
  final String title;
  final String authorId;
  final String authorName;
  final DateTime? createdAt;
  final String? fullImageBase64;

  const DoodleModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.fullImageBase64,
  });

  factory DoodleModel.fromJson(Map<String, dynamic> json) {
    return DoodleModel(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      authorId: (json['authorId'] ?? '') as String,
      authorName: (json['authorName'] ?? '') as String,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      fullImageBase64: json['fullImageBase64'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'authorId': authorId,
    'authorName': authorName,
    'fullImageBase64': fullImageBase64,
  };

  DoodleModel copyWith({
    String? id,
    String? title,
    String? authorId,
    String? authorName,
    String? previewBase64,
    String? fullImageBase64,
    DateTime? createdAt,
  }) {
    return DoodleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      fullImageBase64: fullImageBase64 ?? this.fullImageBase64,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
