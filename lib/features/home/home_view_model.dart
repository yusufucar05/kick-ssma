
import 'package:flutter/material.dart';
import 'package:ssma/core/utils/database_helper.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class HomeViewModel extends ChangeNotifier {
  List<StreamPreset> _presets = [];
  bool _isLoading = true;

  List<StreamPreset> get presets => _presets;
  bool get isLoading => _isLoading;

  Future<void> loadPresets() async {
    _isLoading = true;
    notifyListeners();
    _presets = await DatabaseHelper.instance.getAllPresets();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPreset(StreamPreset preset) async {
    await DatabaseHelper.instance.createPreset(preset);
    await loadPresets();
  }


  Future<void> deletePreset(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('presets', where: 'id = ?', whereArgs: [id]);
    await loadPresets();
  }
}