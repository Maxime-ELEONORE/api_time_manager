import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import 'package:time_manager_app/models/user.dart';

class LocalStorageService {
  static late final SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveObject(String key, dynamic value) async {
    String jsonString = jsonEncode(value);
    return _preferences.setString(key, jsonString);
  }

  static T? getObject<T>(String key, T Function(Map<String, dynamic>) creator) {
    String? jsonString = _preferences.getString(key);
    if (jsonString == null) return null;
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return creator(jsonMap);
  }

  static Future<bool> saveCsrfToken(String token) async {
    return _preferences.setString("csrf_token", token);
  }

  static Future<bool> saveToken(String token) async {
    return _preferences.setString("token_auth", token);
  }

  static Future<bool> saveUserData(dynamic value) async {
    String jsonString = jsonEncode(value);
    return _preferences.setString("current_user", jsonString);
  }

  static Future<bool> saveString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static Future<bool> removeString(String key) async {
    return _preferences.remove(key);
  }

  static Future<bool> removeObject(String key) async {
    return _preferences.remove(key);
  }

  static Future<bool> clearStorage() async {
    return _preferences.clear();
  }

  static User? getUser() {
    return getObject("current_user", (json) => User.fromJsonForToken(json));
  }

  static String? getToken() {
    return getString("token_auth");
  }

  static String? getCsrfToken() {
    return getString("csrf_token");
  }
}
