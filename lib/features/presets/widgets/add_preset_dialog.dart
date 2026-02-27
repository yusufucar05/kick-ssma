import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class AddPresetDialog extends StatefulWidget {
  const AddPresetDialog({super.key});

  @override
  State<AddPresetDialog> createState() => _AddPresetDialogState();
}

class _AddPresetDialogState extends State<AddPresetDialog> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();
  List<String> tags = [];
  bool isMature = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yeni Şablon Oluştur",
            style: TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),


          _buildTextField("Yayın Başlığı", _titleController, Icons.title),
          const SizedBox(height: 20),


          _buildTextField("Kategori (örn: Just Chatting)", _categoryController, Icons.category),
          const SizedBox(height: 20),


          Row(
            children: [
              Expanded(child: _buildTextField("Etiket Yaz", _tagController, Icons.tag)),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_tagController.text.isNotEmpty) {
                    setState(() {
                      tags.add(_tagController.text);
                      _tagController.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.kickGreen),
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),


          Wrap(
            spacing: 8,
            children: tags.map((t) => Chip(
              label: Text(t, style: const TextStyle(fontSize: 10)),
              onDeleted: () => setState(() => tags.remove(t)),
            )).toList(),
          ),

          const SizedBox(height: 20),


          SwitchListTile(
            title: Text("+18 (Mature Content)", style: TextStyle(color: AppColors.text)),
            value: isMature,
            activeColor: AppColors.kickGreen,
            onChanged: (val) => setState(() => isMature = val),
          ),

          const SizedBox(height: 30),


          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kickGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {

                final newPreset = StreamPreset(
                  title: _titleController.text,
                  categoryName: _categoryController.text,
                  categoryImageUrl: "",
                  tags: tags,
                  isMature: isMature,
                );
                Navigator.pop(context, newPreset);
              },
              child: const Text("Şablonu Kaydet", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.text),
        prefixIcon: Icon(icon, color: AppColors.kickGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.kickGreen),
        ),
      ),
    );
  }
}