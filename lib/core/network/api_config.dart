import 'package:flutter/foundation.dart';

class ApiConfig {
  // Default for physical device on same LAN as development machine.
  // Override when needed:
  // flutter run --dart-define=API_BASE_URL=http://<LAN_IP>:3000
  // For Android emulator only, use:
  // flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
  static const String _defaultBaseUrl = 'http://192.168.100.223:3000';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static Uri uri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalizedPath');
  }
}
