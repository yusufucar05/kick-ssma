import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/presentation/viewmodels/home_view_model.dart';

class UserCard extends StatelessWidget {
  final HomeViewModel viewModel;
  const UserCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AppColors.kickGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.kickGreen, width: 2),
                    ),
                    child: viewModel.profilePic.isNotEmpty
                        ? ClipOval(child: Image.network(viewModel.profilePic, fit: BoxFit.cover))
                        : const Icon(Icons.person_rounded, color: AppColors.kickGreen, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.userName,
                          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(AppStrings.menuSubtitle, style: TextStyle(color: AppColors.kickGreen, fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(viewModel.followerCount, AppStrings.statFollower),
                  _buildStatItem(viewModel.subscriberCount, AppStrings.statSubscriber),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Container(
          width: 85,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(value, style: const TextStyle(color: AppColors.kickGreen, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: AppColors.text, fontSize: 10)),
      ],
    );
  }
}