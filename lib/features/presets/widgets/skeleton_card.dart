import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(width: 120, height: 20, decoration: _skeletonDecoration()),
          const SizedBox(height: 20),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: _skeletonDecoration(),
            ),
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Container(width: 40, height: 15, decoration: _skeletonDecoration()),
              const SizedBox(width: 10),
              Container(width: 40, height: 15, decoration: _skeletonDecoration()),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _skeletonDecoration() {
    return BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(10),
    );
  }
}