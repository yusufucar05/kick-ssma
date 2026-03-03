import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/presentation/views/preset_grid.dart';
import 'package:ssma/presentation/views/sidebar.dart';
import 'package:ssma/features/backup/backup_page.dart';
import 'package:ssma/presentation/viewmodels/home_view_model.dart';
import 'package:ssma/presentation/views/trash_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeViewModel _viewModel = HomeViewModel();
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _viewModel.initialize();
    _viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [

          Sidebar(
            viewModel: _viewModel,
            onThemeChanged: (mode) => setState(() {}),
            onPageChanged: (index) => setState(() => _currentIndex = index),
          ),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return BackupPage(viewModel: _viewModel);
      case 2:
        return TrashPage(viewModel: _viewModel);
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Yayın Şablonlarım",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(child: PresetGrid(viewModel: _viewModel)),
          ],
        );
    }
  }
}
