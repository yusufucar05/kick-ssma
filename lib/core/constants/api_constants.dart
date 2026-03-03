import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String authUrl = 'https://id.kick.com/oauth/authorize';
  static const String tokenUrl = 'https://id.kick.com/oauth/token';

  static const String publicBaseUrl = 'https://api.kick.com/public/v1';
  static const String websiteBaseUrl = 'https://kick.com/api/v1';

  static String get clientId => dotenv.env['KICK_CLIENT_ID'] ?? '';
  static String get clientSecret => dotenv.env['KICK_CLIENT_SECRET'] ?? '';

  static const String redirectUri = 'http://localhost:8080/callback';
  static const String customUriScheme = 'http';


  static const List<String> scopes = ['user:read', 'channel:read', 'channel:write'];
}