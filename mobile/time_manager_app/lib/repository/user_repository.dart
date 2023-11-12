import 'dart:convert';

import 'package:time_manager_app/constants/api_conf.dart';
import 'package:time_manager_app/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static final UserRepository _instance = UserRepository._();

  UserRepository._();

  factory UserRepository() {
    return _instance;
  }

  Future<User> getUser(String id) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}/users/$id");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}/users");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user), // Convert User object to JSON string
      );
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to create a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}/users/$id");
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}/users");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => User.fromJson(e))
            .toList();
      } else {
        throw Exception(
            'Failed to get Users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}/users/${user.id}");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user), // Convert User object to JSON string
      );
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to update a User. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
