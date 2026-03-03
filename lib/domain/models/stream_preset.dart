import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/utils/app_logger.dart';

class StreamPreset {
  final int? id;
  final String title;
  final String categoryName;
  final List<String> tags;
  final bool isMature;
  final int? categoryId;
  final String? categoryImageUrl;
  final String createdDate;
  final String? deletedDate;

  StreamPreset({
    this.id,
    required this.title,
    required this.categoryName,
    required this.tags,
    this.isMature = false,
    this.categoryId,
    this.categoryImageUrl,
    String? createdDate,
    this.deletedDate,
  }) : createdDate = createdDate ?? _formatDate(DateTime.now());

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  bool get isDeleted => deletedDate != null;

  int get daysUntilPermanentDelete {
    if (deletedDate == null) return 4;
    final deleted = DateTime.parse(deletedDate!);
    final diff = 4 - DateTime.now().difference(deleted).inDays;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryName': categoryName,
      'tags': tags.join(','),
      'isMature': isMature ? 1 : 0,
      'categoryId': categoryId ?? 0,
      'categoryImageUrl': categoryImageUrl ?? '',
      'createdDate': createdDate,
      'deletedDate': deletedDate,
    };
  }

  factory StreamPreset.fromMap(Map<String, dynamic> map) {
    try {
      return StreamPreset(
        id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
        title: map['title']?.toString() ?? AppStrings.unknownPreset,
        categoryName: map['categoryName']?.toString() ?? '',
        tags: (map['tags'] != null && map['tags'].toString().isNotEmpty)
            ? map['tags'].toString().split(',')
            : [],
        isMature: map['isMature'] == 1 || map['isMature'] == true || map['isMature'] == '1',
        categoryId: int.tryParse(map['categoryId']?.toString() ?? '0') ?? 0,
        categoryImageUrl: map['categoryImageUrl']?.toString() ?? '',
        createdDate: map['createdDate']?.toString() ?? _formatDate(DateTime.now()),
        deletedDate: map['deletedDate']?.toString(),
      );
    } catch (e) {
      logger.e(AppStrings.logParseErr, error: e);
      return StreamPreset(title: AppStrings.brokenPreset, categoryName: '', tags: []);
    }
  }
}