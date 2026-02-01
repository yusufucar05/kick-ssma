class StreamPreset {
  final String id;
  final String title;
  final String category;
  final String coverImage;
  final List<String> tags;
  final bool isAdult;

  StreamPreset({
    required this.id,
    required this.title,
    required this.category,
    required this.coverImage,
    required this.tags,
    required this.isAdult,
  });
}
