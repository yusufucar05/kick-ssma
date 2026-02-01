import 'package:flutter/material.dart';

class AddPresetCard extends StatelessWidget {
  const AddPresetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Icon(Icons.add, size: 48),
      ),
    );

  }
}

