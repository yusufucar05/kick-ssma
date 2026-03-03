import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/domain/models/stream_preset.dart';
import 'package:ssma/presentation/viewmodels/home_view_model.dart';
import 'package:ssma/features/presets/widgets/preset_card.dart';
import 'package:ssma/features/presets/widgets/add_preset_dialog.dart';
import 'package:ssma/features/presets/widgets/skeleton_card.dart';
import 'package:ssma/data/remote/kick_api_service.dart';

class PresetGrid extends StatefulWidget {
  final HomeViewModel viewModel;
  const PresetGrid({super.key, required this.viewModel});

  @override
  State<PresetGrid> createState() => _PresetGridState();
}

class _PresetGridState extends State<PresetGrid> {
  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.isLoading) {
      return _buildLoadingGrid();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3;

    if (screenWidth < 1100) {
      crossAxisCount = 2;
    }
    if (screenWidth < 750) {
      crossAxisCount = 1;
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        childAspectRatio: 0.82,
      ),
      itemCount: widget.viewModel.presets.length + 1,
      itemBuilder: (context, index) {

        if (index == 0) {
          return _buildAddButton(context);
        }

        final preset = widget.viewModel.presets[index - 1];

        return PresetCard(
          preset: preset,
          onEdit: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: AddPresetDialog(existingPreset: preset),
              ),
            );
            if (result != null && result is StreamPreset) {
              await widget.viewModel.editPreset(result);
            }
          },
          onDelete: () async {
            if (preset.id != null) {
              await widget.viewModel.deletePreset(preset.id!);
            }
          },
          onApply: () async {
            if (!widget.viewModel.isConnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.notConnectedError),
                  backgroundColor: Colors.redAccent,
                  action: SnackBarAction(
                    label: AppStrings.menuConnect,
                    textColor: AppColors.kickGreen,
                    onPressed: () => widget.viewModel.connectToKick(),
                  ),
                ),
              );
              return;
            }
              final api = KickApiService();
              int? catId = preset.categoryId;

              if (catId == null || catId == 0) {
                final searchResult = await api.searchCategoryDetailed(preset.categoryName);
                catId = searchResult?['id'];
              }

              if (catId != null) {

                bool ok = await api.updateChannel(catId, preset.title, preset.tags, preset.isMature);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? "${preset.title} ${AppStrings.applySuccess}" : AppStrings.applyFail),
                      backgroundColor: ok ? AppColors.kickGreen : Colors.red,
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.categoryNotFound),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(25),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }


  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.kickGreen.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => const Dialog(
                backgroundColor: Colors.transparent,
                child: AddPresetDialog(),
              ),
            );
            if (result != null && result is StreamPreset) {
              widget.viewModel.addPreset(result);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.kickGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 70,
                  color: AppColors.kickGreen,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                AppStrings.addPresetTitle,
                style: TextStyle(
                  color: AppColors.kickGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppStrings.addPresetSub ,
                textAlign: TextAlign.center,

                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}