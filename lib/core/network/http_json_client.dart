import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpJsonClient {
  final http.Client _client;

  HttpJsonClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> postJson(
    Uri uri,
    Map<String, dynamic> body,
  ) async {
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final dynamic decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    final map = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'message': response.body};

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(map['message'] ?? 'Request failed');
    }

    return map;
  }
}
