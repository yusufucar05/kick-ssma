import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/domain/models/stream_preset.dart';

class PresetCard extends StatelessWidget {
  final StreamPreset preset;
  final VoidCallback onDelete;
  final VoidCallback onApply;
  final VoidCallback onEdit;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onDelete,
    required this.onApply,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child:
                          (preset.categoryImageUrl != null &&
                              preset.categoryImageUrl!.isNotEmpty)
                          ? Image.network(
                              preset.categoryImageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),

                  const SizedBox(width: 12),


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: onEdit,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),


                        Text(
                          preset.title,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        Text(
                          preset.categoryName,
                          style: const TextStyle(
                            color: AppColors.kickGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 8),


                        Text(
                          '${AppStrings.createdLabel} ${preset.createdDate}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (preset.tags.isNotEmpty)
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: preset.tags
                  .take(12)
                  .map((tag) => _buildTag(tag))
                  .toList(),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kickGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.btnApply,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kickGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          preset.categoryName.isNotEmpty
              ? preset.categoryName[0].toUpperCase()
              : '?',
          style: TextStyle(
            color: AppColors.kickGreen.withOpacity(0.4),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.kickGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.kickGreen.withOpacity(0.25)),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppColors.kickGreen,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
