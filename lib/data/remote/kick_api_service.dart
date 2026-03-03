import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/utils/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ssma/core/constants/api_constants.dart';

class KickApiService {
  static final KickApiService _instance = KickApiService._internal();
  factory KickApiService() => _instance;
  KickApiService._internal();

  final _storage = const FlutterSecureStorage();


  String _generateCodeVerifier() {
    var random = Random.secure();
    var values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    var bytes = utf8.encode(verifier);
    var digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<Map<String, dynamic>?> getFollowerData(String slug) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.websiteBaseUrl}/channels/$slug'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      logger.e(AppStrings.logFollowerErr, error: e);
    }
    return null;
  }

  Future<bool> loginWithKick() async {
    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

      final authUrl = Uri.parse(ApiConstants.authUrl).replace(queryParameters: {
        'response_type': 'code',
        'client_id': ApiConstants.clientId,
        'redirect_uri': ApiConstants.redirectUri,
        'scope': ApiConstants.scopes.join(' '),
        'state': 'ssma_secure_123',
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      });

      if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
        await server.close();
        return false;
      }


      bool result = false;
      try {
        await for (var request in server.timeout(const Duration(seconds: 60))) {
          final code = request.uri.queryParameters['code'];
          final error = request.uri.queryParameters['error'];

          if (error != null) {

            request.response
              ..statusCode = 200
              ..headers.contentType = ContentType.html
              ..write( [
                'user:read',
                'channel:read',
                'channel:write',
              ]);
            await request.response.close();
            result = false;
            break;
          }

          if (code != null) {
            request.response
              ..statusCode = 200
              ..headers.contentType = ContentType.html
              ..write(AppStrings.loginSuccess);
            await request.response.close();
            result = await _exchangeCodeForToken(code, codeVerifier);
            break;
          }
        }
      } on TimeoutException {
        logger.w(AppStrings.logLoginTimeout);
        result = false;
      }

      await server.close(force: true);
      return result;

    } catch (e) {
      logger.e(AppStrings.logLoginErr, error: e);
      return false;
    }
  }

  Future<bool> _exchangeCodeForToken(String code, String codeVerifier) async {
    final response = await http.post(
      Uri.parse(ApiConstants.tokenUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'grant_type': 'authorization_code',
        'client_id': ApiConstants.clientId,
        'client_secret': ApiConstants.clientSecret,
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': ApiConstants.redirectUri,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(
        key: 'kick_access_token',
        value: data['access_token'],
      );
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final response = await _authGet('${ApiConstants.publicBaseUrl}/users');
      return response.statusCode == 200 ? json.decode(response.body) : null;
    } catch (e) {
      logger.e(AppStrings.logApiCrash, error: e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getChannelData() async {
    try {
      final response = await _authGet('${ApiConstants.publicBaseUrl}/channels');
      return response.statusCode == 200 ? json.decode(response.body) : null;
    } catch (e) {
      logger.e(AppStrings.logApiCrash, error: e);
      return null;
    }
  }


  Future<Map<String, dynamic>?> searchCategoryDetailed(String query) async {
    try {
      final token = await _storage.read(key: 'kick_access_token');
      if (token == null) return null;
      final url = Uri.parse(
        '${ApiConstants.publicBaseUrl}/categories',
      ).replace(queryParameters: {'q': query});
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && (data['data'] as List).isNotEmpty) {
          final category = data['data'][0];
          String imageUrl = category['thumbnail'] ?? category['banner']?['url'] ?? category['icon']?['url'] ?? "";

          return {
            'id': category['id'],
            'name': category['name'],
            'image': imageUrl,
          };
        }
      }
    } catch (e) {
      logger.e(AppStrings.logSearchErr, error: e);
    }
    return null;
  }

  Future<bool> updateChannel(int categoryId, String title, List<String> tags, bool isMature) async {
    final token = await _storage.read(key: 'kick_access_token');
    if (token == null) {
      logger.w(AppStrings.logNoToken);
      return false;
    }

    final Map<String, dynamic> payload = {
      'category_id': categoryId,
      'stream_title': title,
      'is_mature': isMature,

      'tags': tags,
    };

    logger.d("${AppStrings.logApiPayload}: ${jsonEncode(payload)}");

    try {
      final response = await http.patch(
        Uri.parse('${ApiConstants.publicBaseUrl}/channels'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      logger.d("${AppStrings.logApiResponse}: ${response.statusCode} - ${response.body}");
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      logger.e(AppStrings.logApiCrash, error: e);
      return false;
    }
  }

  Future<bool> isTokenValid() async {
    final token = await _storage.read(key: 'kick_access_token');
    if (token == null) return false;

    final response = await http.get(
      Uri.parse('${ApiConstants.publicBaseUrl}/users'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 401) {
      await _storage.delete(key: 'kick_access_token');
      return false;
    }
    return response.statusCode == 200;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'kick_access_token');
  }


  Future<http.Response> _authGet(String url) async {
    final token = await _storage.read(key: 'kick_access_token');
    if (token == null) throw Exception(AppStrings.logNoToken);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 401) {
      await _storage.delete(key: 'kick_access_token');
      throw Exception(AppStrings.logTokenExpired);
    }
    return response;
  }
}
