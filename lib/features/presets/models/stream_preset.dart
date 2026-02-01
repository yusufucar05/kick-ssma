class StreamPreset {
  final int? id;
  final String title;
  final String categoryName;
  final String categoryImageUrl;
  final List<String> tags;
  final bool isMature;

  StreamPreset({
    this.id,
    required this.title,
    required this.categoryName,
    required this.categoryImageUrl,
    required this.tags,
    this.isMature = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryName': categoryName,
      'categoryImageUrl': categoryImageUrl,
      'tags': tags.join(','),
      'isMature': isMature ? 1 : 0,
    };
  }

  factory StreamPreset.fromMap(Map<String, dynamic> map) {
    return StreamPreset(
      id: map['id'],
      title: map['title'],
      categoryName: map['categoryName'],
      categoryImageUrl: map['categoryImageUrl'],
      tags: (map['tags'] as String).split(','),
      isMature: map['isMature'] == 1,
    );
  }
}