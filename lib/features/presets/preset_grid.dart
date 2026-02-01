import 'package:flutter/material.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';
import 'widgets/preset_card.dart';
import 'widgets/add_preset_card.dart';

class PresetGrid extends StatelessWidget {
  PresetGrid({super.key});

  final presets = [
    StreamPreset(
      id: '1',
      title: '🔥 Just Chatting',
      category: 'Just Chatting',
      coverImage: 'assets/cover.jpg',
      tags: ['sohbet', 'türkçe', 'chill'],
      isAdult: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: presets.length + 1,
        itemBuilder: (context, index) {
          if (index == presets.length) {
            return const AddPresetCard();
          }
          return PresetCard(
            preset: presets[index],
            onEdit: () {},
          );
        },
      ),
    );
  }
}
