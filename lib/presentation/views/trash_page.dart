import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/domain/models/stream_preset.dart';
import 'package:ssma/presentation/viewmodels/home_view_model.dart';

class TrashPage extends StatelessWidget {
  final HomeViewModel viewModel;
  const TrashPage({super.key, required this.viewModel});

  static Color dayColor(int days) {
    if (days <= 1) return Colors.redAccent;
    if (days <= 2) return Colors.orange;
    if (days <= 3) return Colors.orangeAccent;
    return Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final deleted = viewModel.deletedPresets;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.trashTitle,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.trashSubtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    _colorBadge(Colors.yellow, "4 gün"),
                    const SizedBox(width: 10),
                    _colorBadge(Colors.orangeAccent, "3 gün"),
                    const SizedBox(width: 10),
                    _colorBadge(Colors.orange, "2 gün"),
                    const SizedBox(width: 10),
                    _colorBadge(Colors.redAccent, "Son gün"),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: deleted.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 80,
                            color: Colors.grey.withOpacity(0.3)),
                        const SizedBox(height: 15),
                        Text(
                          AppStrings.trashEmpty,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    itemCount: deleted.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final preset = deleted[index];
                      return _TrashItem(
                        preset: preset,
                        isPreview: false,
                        onRestore: () =>
                            viewModel.restorePreset(preset.id!),
                        onPermanentDelete: () =>
                            _confirmPermanentDelete(context, preset.id!),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorBadge(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  void _confirmPermanentDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.trashDeleteConfirmTitle,
            style: TextStyle(color: AppColors.text)),
        content: Text(AppStrings.trashDeleteConfirmBody,
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel,
                style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              viewModel.permanentDeletePreset(id);
            },
            child: Text(AppStrings.trashDeleteConfirmBtn,
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _TrashItem extends StatelessWidget {
  final StreamPreset preset;
  final VoidCallback onRestore;
  final VoidCallback onPermanentDelete;
  final bool isPreview;

  const _TrashItem({
    required this.preset,
    required this.onRestore,
    required this.onPermanentDelete,
    required this.isPreview,
  });

  Color get _dayColor => TrashPage.dayColor(preset.daysUntilPermanentDelete);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _dayColor),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: _dayColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 55,
                        height: 70,
                        child: (preset.categoryImageUrl != null &&
                            preset.categoryImageUrl!.isNotEmpty)
                            ? Image.network(
                          preset.categoryImageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => _letterAvatar(),
                        )
                            : _letterAvatar(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preset.title,
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.redAccent,
                              decorationThickness: 2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preset.categoryName,
                            style: const TextStyle(
                              color: AppColors.kickGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore_rounded,
                              color: AppColors.kickGreen, size: 22),
                          tooltip: AppStrings.trashRestore,
                          onPressed: isPreview ? null : onRestore,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever_rounded,
                              color: Colors.redAccent, size: 22),
                          tooltip: AppStrings.trashDeleteForever,
                          onPressed: isPreview ? null : onPermanentDelete,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (preset.tags.isNotEmpty)
                  Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: preset.tags
                        .take(5)
                        .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(tag,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 9)),
                    ))
                        .toList(),
                  ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _dayColor.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _dayColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 10, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${AppStrings.createdLabel} ${preset.createdDate}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 10),
                      ),
                      const Spacer(),
                      Icon(Icons.timer_outlined, size: 10, color: _dayColor),
                      const SizedBox(width: 4),
                      Text(
                        '${AppStrings.trashDaysLeft} ${preset.daysUntilPermanentDelete} ${AppStrings.trashDays}',
                        style: TextStyle(
                          color: _dayColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _letterAvatar() {
    return Container(
      color: Colors.redAccent.withOpacity(0.1),
      child: Center(
        child: Text(
          preset.categoryName.isNotEmpty
              ? preset.categoryName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}