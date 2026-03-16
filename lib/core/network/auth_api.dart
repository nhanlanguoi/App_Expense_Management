import 'package:expense_management/core/network/api_config.dart';
import 'package:expense_management/core/network/http_json_client.dart';

class AuthApi {
  final HttpJsonClient _client;

  AuthApi({HttpJsonClient? client}) : _client = client ?? HttpJsonClient();

  Future<Map<String, dynamic>> register({
    required String identifier,
    required String password,
    String? displayName,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/register'),
      {
        'identifier': identifier,
        'password': password,
        if (displayName != null && displayName.isNotEmpty) 'displayName': displayName,
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/login'),
      {'identifier': identifier, 'password': password},
    );
  }

  Future<Map<String, dynamic>> loginWithGoogle({required String idToken}) {
    return _client.postJson(
      ApiConfig.uri('/auth/firebase'),
      {'idToken': idToken},
    );
  }

  Future<Map<String, dynamic>> loginWithFacebook({required String idToken}) {
    return _client.postJson(
      ApiConfig.uri('/auth/firebase'),
      {'idToken': idToken},
    );
  }

  Future<Map<String, dynamic>> loginWithFirebase({required String idToken}) {
    return _client.postJson(
      ApiConfig.uri('/auth/firebase'),
      {'idToken': idToken},
    );
  }

  Future<Map<String, dynamic>> logout() {
    return _client.postJson(
      ApiConfig.uri('/auth/logout'),
      {},
    );
  }

  Future<Map<String, dynamic>> requestEmailOtp({
    required String email,
    required String purpose,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/email-otp/request'),
      {
        'email': email,
        'purpose': purpose,
      },
    );
  }

  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String email,
    required String code,
    required String password,
    String? displayName,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/email-otp/verify-register'),
      {
        'email': email,
        'code': code,
        'password': password,
        if (displayName != null && displayName.isNotEmpty) 'displayName': displayName,
      },
    );
  }

  Future<Map<String, dynamic>> verifyResetOtp({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _client.postJson(
      ApiConfig.uri('/auth/email-otp/verify-reset'),
      {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      },
    );
  }
}
