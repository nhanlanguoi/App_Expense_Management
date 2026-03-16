import 'package:expense_management/core/network/api_config.dart';
import 'package:expense_management/core/network/http_json_client.dart';

class AuthApi {
  final HttpJsonClient _client;

  AuthApi({HttpJsonClient? client}) : _client = client ?? HttpJsonClient();

  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/register'),
      {'username': username, 'password': password},
    );
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/login'),
      {'username': username, 'password': password},
    );
  }

  Future<Map<String, dynamic>> loginWithGoogle({required String idToken}) {
    return _client.postJson(
      ApiConfig.uri('/auth/google'),
      {'idToken': idToken},
    );
  }

  Future<Map<String, dynamic>> loginWithFacebook({required String idToken}) {
    return _client.postJson(
      ApiConfig.uri('/auth/facebook'),
      {'idToken': idToken},
    );
  }
}
