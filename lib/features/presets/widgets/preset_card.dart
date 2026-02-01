import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class PresetCard extends StatelessWidget {
  final StreamPreset preset;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onApply;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onEdit,
    required this.onDelete,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          preset.title,
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        preset.categoryName.isNotEmpty ? preset.categoryName[0].toUpperCase() : "?",
                        style: const TextStyle(color: AppColors.kickGreen, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),


                  Text(
                    preset.categoryName,
                    style: TextStyle(color: AppColors.surface, fontSize: 21),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),


                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0.05)],
                          stops: const [0.8, 1.0],
                        ).createShader(bounds);
                      },
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: preset.tags.map((tag) => _buildTag(tag)).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMatureBadge(preset.isMature),
                      GestureDetector(
                        onTap: onApply,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.kickGreen, shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.kickGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.kickGreen.withOpacity(0.2)),
      ),
      child: Text(
        "#$tag",
        style: const TextStyle(color: AppColors.kickGreen, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMatureBadge(bool isMature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMature ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isMature ? "18+" : "SFW",
        style: TextStyle(color: isMature ? Colors.red : Colors.green, fontSize: 21, fontWeight: FontWeight.bold),
      ),
    );
  }
}