import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:time_manager_app/constants/api_conf.dart';
import 'package:time_manager_app/service/local_storage_service.dart';

abstract class AbstractRepository {
  String baseUrl() => ApiConf.baseUrl;

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${LocalStorageService.getToken()}",
        "cookie": "${LocalStorageService.getCsrfToken()}",
      };

  Future<http.Response> get(String path) async {
    final url = Uri.parse("${baseUrl()}$path");
    print("$baseUrl/$path");
    return await _sendRequest(() => http.get(url, headers: _headers));
  }

  Future<http.Response> post(String path, {dynamic body}) async {
    final url = Uri.parse("${baseUrl()}$path");
    return await _sendRequest(
        () => http.post(url, headers: _headers, body: jsonEncode(body)));
  }

  Future<http.Response> put(String path, {dynamic body}) async {
    final url = Uri.parse("${baseUrl()}$path");
    return await _sendRequest(
        () => http.put(url, headers: _headers, body: jsonEncode(body)));
  }

  Future<http.Response> delete(String path, {dynamic body}) async {
    final url = Uri.parse("${baseUrl()}$path");
    return await _sendRequest(
        () => http.delete(url, headers: _headers, body: jsonEncode(body)));
  }

  Future<http.Response> patch(String path, {dynamic body}) async {
    final url = Uri.parse("${baseUrl()}$path");
    return await _sendRequest(
        () => http.patch(url, headers: _headers, body: jsonEncode(body)));
  }

  Future<http.Response> abstractSignIn(String path, {dynamic body}) async {
    final url = Uri.parse("${baseUrl()}$path");
    return await _sendRequestForSingIn(
        () => http.post(url, headers: _headers, body: jsonEncode(body)));
  }

  Future<http.Response> _sendRequest(
      Future<http.Response> Function() request) async {
    final response = await request();
    _updateCsrfToken(response);
    return _processResponse(response);
  }

  Future<http.Response> _sendRequestForSingIn(
      Future<http.Response> Function() request) async {
    final response = await request();
    LocalStorageService.saveToken(
        jsonDecode(response.body)["token"].toString());
    _updateCsrfToken(response);
    return _processResponse(response);
  }

  void _updateCsrfToken(http.Response response) {
    if (response.headers.containsKey('set-cookie')) {
      LocalStorageService.saveCsrfToken(response.headers['set-cookie']!);
    }
  }

  http.Response _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
          'Failed to perform request. Status code: ${response.statusCode}');
    }
  }
}
