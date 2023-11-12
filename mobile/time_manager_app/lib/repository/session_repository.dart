import 'dart:convert';

import 'package:time_manager_app/constants/api_conf.dart';
import 'package:time_manager_app/repository/abstract_repository.dart';
import 'package:time_manager_app/service/local_storage_service.dart';
import 'package:http/http.dart' as http;

class SessionRepository extends AbstractRepository {
  static final SessionRepository _instance = SessionRepository._();
  SessionRepository._();

  factory SessionRepository() {
    return _instance;
  }

  Future<dynamic> signIn(String email, String password) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}sign_in");
      Map<String, String> usersMap = {
        "hash_password": password,
        "email": email
      };
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(usersMap));
      if (response.statusCode == 200) {
        await LocalStorageService.saveCsrfToken(
            response.headers["set-cookie"].toString());
        await LocalStorageService.saveUserData(jsonDecode(response.body));
        await LocalStorageService.saveToken(
            jsonDecode(response.body)["token"].toString());
      } else {
        throw Exception(
            'Failed to create a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> signInn(String email, String password) async {
    try {
      Map<String, String> usersMap = {
        "hash_password": password,
        "email": email
      };
      final response = await super.abstractSignIn("sign_in", body: usersMap);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception(
            'Failed to create a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
