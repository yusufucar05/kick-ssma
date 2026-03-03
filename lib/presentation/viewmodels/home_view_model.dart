import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/utils/app_logger.dart';
import 'package:ssma/core/utils/database_helper.dart';
import 'package:ssma/domain/models/stream_preset.dart';
import 'package:ssma/data/remote/kick_api_service.dart';

class HomeViewModel extends ChangeNotifier {
  List<StreamPreset> _presets = [];
  List<StreamPreset> _deletedPresets = [];
  bool _isLoading = true;
  bool _isConnecting = false;

  String userName = '';
  String profilePic = '';
  String followerCount = '?';
  String subscriberCount = '?';
  bool isConnected = false;

  List<StreamPreset> get presets => _presets;
  List<StreamPreset> get deletedPresets => _deletedPresets;
  bool get isLoading => _isLoading;
  bool get isConnecting => _isConnecting;

  
  Future<void> initialize() async {
    await loadPresets();
    await _tryAutoLogin();
  }

  
  Future<void> _tryAutoLogin() async {
    final apiService = KickApiService();
    final tokenValid = await apiService.isTokenValid();

    if (!tokenValid) {
      isConnected = false;
      notifyListeners();
      return;
    }

    await _loadUserData(apiService);
  }

  Future<void> connectToKick() async {
    _isConnecting = true;
    notifyListeners();

    try {
      final apiService = KickApiService();
      bool success = await apiService.loginWithKick();

      if (success) {
        await _loadUserData(apiService);
      }
    } catch (e) {
      logger.e(AppStrings.logLoginErr, error: e);
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  
  Future<void> _loadUserData(KickApiService apiService) async {
    try {
      final userData = await apiService.getUserData();
      final channelData = await apiService.getChannelData();

      if (userData != null && userData['data'] != null) {
        final user = userData['data'][0];
        userName = user['name'] ?? 'Bilinmiyor';
        profilePic = user['profile_picture'] ?? '';

        String slug = '';
        if (channelData != null && channelData['data'] != null) {
          final ch = channelData['data'][0];
          slug = ch['slug'] ?? '';
          subscriberCount = (ch['active_subscribers_count'] ?? 0).toString();
        }

        if (slug.isNotEmpty) {
          final followerData = await apiService.getFollowerData(slug);
          if (followerData != null) {
            followerCount = (followerData['followersCount'] ?? '?').toString();
          }
        }

        isConnected = true;
        notifyListeners();
      }
    } catch (e) {
      
      isConnected = false;
      userName = '';
      profilePic = '';
      followerCount = '?';
      subscriberCount = '?';
      logger.w(AppStrings.logTokenExpired);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await KickApiService().logout();
    isConnected = false;
    userName = '';
    profilePic = '';
    followerCount = '?';
    subscriberCount = '?';
    notifyListeners();
  }

  Future<void> loadPresets() async {
    _isLoading = true;
    notifyListeners();
    try {
      await DatabaseHelper.instance.cleanupExpiredPresets();
      _presets = await DatabaseHelper.instance.getAllPresets();
      _deletedPresets = await DatabaseHelper.instance.getDeletedPresets();
    } catch (e) {
      logger.e(AppStrings.logDbErr, error: e);
      _presets = [];
      _deletedPresets = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPreset(StreamPreset preset) async {
    await DatabaseHelper.instance.createPreset(preset);
    await loadPresets();
  }

  Future<void> editPreset(StreamPreset preset) async {
    await DatabaseHelper.instance.updatePreset(preset);
    await loadPresets();
  }

  Future<void> deletePreset(int id) async {
    await DatabaseHelper.instance.softDeletePreset(id);
    await loadPresets();
  }

  Future<void> restorePreset(int id) async {
    await DatabaseHelper.instance.restorePreset(id);
    await loadPresets();
  }

  Future<void> permanentDeletePreset(int id) async {
    await DatabaseHelper.instance.permanentDeletePreset(id);
    await loadPresets();
  }
}