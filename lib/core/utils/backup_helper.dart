  import 'dart:convert';
  import 'dart:io';
  import 'package:file_picker/file_picker.dart';
  import 'package:ssma/core/constants/app_strings.dart';
  import 'package:ssma/core/utils/app_logger.dart';
  import 'package:ssma/domain/models/stream_preset.dart';

  class BackupHelper {
    static Future<bool> exportBackup(List<StreamPreset>? presets) async {
      try {
        if (presets == null || presets.isEmpty) return false;
        final List<Map<String, dynamic>> data = presets.map((e) => e.toMap()).toList();
        final String jsonString = jsonEncode(data);

        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: AppStrings.backupDialog,
          fileName: AppStrings.backupFileName,
          type: FileType.custom,
          allowedExtensions: ['ssma'],
        );

        if (outputFile != null) {
          final path = outputFile.endsWith('.ssma') ? outputFile : '$outputFile.ssma';
          final file = File(path);
          await file.writeAsString(jsonString);
          return true;
        }
      } catch (e) { logger.e(AppStrings.logExportErr, error: e); }
      return false;
    }

    static Future<List<StreamPreset>> importBackup() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['ssma'],
          allowMultiple: false,
        );
        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          final String content = await file.readAsString();
          final List<dynamic> jsonData = jsonDecode(content);

          return jsonData.map((e) => StreamPreset.fromMap(e as Map<String, dynamic>)).toList();
        }
      } catch (e) { logger.e(AppStrings.logImportErr, error: e); }
      return [];
    }
  }