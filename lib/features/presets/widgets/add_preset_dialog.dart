import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/domain/models/stream_preset.dart';
import 'package:ssma/data/remote/kick_api_service.dart';

class AddPresetDialog extends StatefulWidget {
  final StreamPreset? existingPreset;

  const AddPresetDialog({super.key, this.existingPreset});

  @override
  State<AddPresetDialog> createState() => _AddPresetDialogState();
}

class _AddPresetDialogState extends State<AddPresetDialog> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();
  List<String> tags = [];
  bool isMature = false;
  int? _selectedCategoryId;
  String? _selectedImageUrl;
  bool _isSearching = false;

  bool get _isEditMode => widget.existingPreset != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final p = widget.existingPreset!;
      _titleController.text = p.title;
      _categoryController.text = p.categoryName;
      tags = List.from(p.tags);
      isMature = p.isMature;
      _selectedCategoryId = p.categoryId;
      _selectedImageUrl = p.categoryImageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

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
            _isEditMode ? AppStrings.dialogEditTitle : AppStrings.dialogTitle,
            style: TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),

          _buildTextField(AppStrings.fieldTitle, _titleController, Icons.title),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(AppStrings.fieldCategory, _categoryController, Icons.category),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSearching ? null : _searchKickCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kickGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isSearching
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ],
          ),

          if (_selectedImageUrl != null && _selectedImageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(_selectedImageUrl!, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 15),
                  const Text(AppStrings.categoryOk,
                      style: TextStyle(color: AppColors.kickGreen, fontSize: 12)),
                ],
              ),
            ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildTextField(AppStrings.fieldTag, _tagController, Icons.tag)),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_tagController.text.isNotEmpty) {
                    setState(() {
                      tags.add(_tagController.text.trim());
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
            title: Text(AppStrings.matureLabel, style: TextStyle(color: AppColors.text)),
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
                if (_titleController.text.trim().isEmpty || _categoryController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.presetValidationError),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                final preset = StreamPreset(

                  id: _isEditMode ? widget.existingPreset!.id : null,
                  title: _titleController.text.trim(),
                  categoryName: _categoryController.text.trim(),
                  categoryImageUrl: _selectedImageUrl ?? '',
                  categoryId: _selectedCategoryId,
                  tags: tags,
                  isMature: isMature,

                  createdDate: _isEditMode ? widget.existingPreset!.createdDate : null,
                );
                Navigator.pop(context, preset);
              },
              child: Text(
                _isEditMode ? AppStrings.btnUpdate : AppStrings.btnSave,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchKickCategory() async {
    if (_categoryController.text.isEmpty) return;
    setState(() => _isSearching = true);
    try {
      final api = KickApiService();
      final result = await api.searchCategoryDetailed(_categoryController.text);
      if (result != null) {
        setState(() {
          _categoryController.text = result['name'];
          _selectedCategoryId = result['id'];
          _selectedImageUrl = result['image'];
        });
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
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