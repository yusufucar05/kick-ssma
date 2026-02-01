
import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/core/utils/backup_helper.dart';
import 'package:ssma/features/home/home_view_model.dart';

class BackupPage extends StatelessWidget {
  final HomeViewModel viewModel;
  const BackupPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Yedekleme & Geri Yükleme",
                style: TextStyle(color: AppColors.text, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Şablonlarını .ssma dosyası olarak kaydedebilir veya yedeklerini sisteme aktarabilirsin.",
                style: TextStyle(color: AppColors.surface, fontSize: 16)),
            const SizedBox(height: 50),
            Row(
              children: [
                _actionCard(
                  context,
                  title: "Dışarı Aktar (.ssma)",
                  icon: Icons.upload_file_rounded,
                  onTap: () async {
                    final success = await BackupHelper.exportBackup(viewModel.presets);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Yedek başarıyla oluşturuldu!")),
                      );
                    }
                  },
                ),
                const SizedBox(width: 30),
                _actionCard(
                  context,
                  title: "İçeri Aktar (.ssma)",
                  icon: Icons.file_download_rounded,
                  onTap: () async {
                    final imported = await BackupHelper.importBackup();
                    if (imported.isNotEmpty) {
                      for (var preset in imported) {
                        await viewModel.addPreset(preset);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Şablonlar başarıyla içeri aktarıldı!")),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: AppColors.kickGreen),
              const SizedBox(height: 15),
              Text(title, style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}