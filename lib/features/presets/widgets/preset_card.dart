import 'package:flutter/material.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class PresetCard extends StatelessWidget {
  final StreamPreset preset;
  final VoidCallback onEdit;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_fire_department, size: 20),
                SizedBox(width: 6),
                Text(
                  "Just Chatting",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              "Sohbet + chill yayın",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 6,
              runSpacing: 10,
              children: const [
                Chip(label: Text("sohbet")),
                Chip(label: Text("türkçe")),
                Chip(label: Text("chill")),
                Chip(label: Text("nasıl yani kanka ?")),

              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("+18"),
                Switch(value: false, onChanged: (_) {}),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
