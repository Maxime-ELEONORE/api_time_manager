import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:time_manager_app/constants/api_conf.dart';
import 'package:time_manager_app/models/clock.dart';
import 'package:time_manager_app/models/user.dart';
import 'package:time_manager_app/repository/abstract_repository.dart';
import 'package:time_manager_app/service/local_storage_service.dart';

class ClockRepository extends AbstractRepository {
  static final ClockRepository _clockRepository = ClockRepository._();
  static String host = "10.0.2.2";
  ClockRepository._();
  factory ClockRepository() {
    return _clockRepository;
  }

  Future<Clock> createClock(Clock clock) async {
    try {
      String? token = LocalStorageService.getString("token_auth");
      User? user = LocalStorageService.getObject(
          "current_user", (json) => User.fromJsonForToken(json));
      final url = Uri.parse("${ApiConf.baseUrl}clocks/${user?.id}");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(clock), // Convert Clock object to JSON string
      );

      if (response.statusCode == 200) {
        return Clock.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to create a Clock. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Clock> updateClock(Clock clock) async {
    try {
      final url = Uri.parse("${ApiConf.baseUrl}clock");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(clock),
      );
      if (response.statusCode == 200) {
        return Clock.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to update a Clock. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<void> deleteClock(String id) async {
  //   try {
  //     final url = Uri.parse("${ApiConf.baseUrl}/clock/$id");
  //     final response = await http.delete(url);
  //     if (response.statusCode != 200) {
  //       throw Exception(
  //           'Failed to delete a Clock. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }

  Future<void> deleteClock(String id) async {
    try {
      final response = await super.delete("clocks/$id");
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete a Clock. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Clock> getClock(String id) async {
    try {
      final response = await super.get("clocks/$id");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Clock.fromJson(jsonDecode(response.body)["data"]);
      } else {
        throw Exception(
            'Failed to get a Clock. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Clock>> getClocks() async {
    try {
      final response =
          await super.get("clocks/${LocalStorageService.getUser()?.id}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Iterable data = jsonDecode(response.body)["data"];
        return List<Clock>.from(data.map((model) => Clock.fromJson(model)));
      } else {
        throw Exception(
            'Failed to get Clocks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
