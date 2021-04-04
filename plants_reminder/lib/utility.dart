import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class Utility {
  static const String serverIP = "127.0.0.1";
  static const int serverPort = 5436;
  static String serverUrl = serverIP + ":" + serverPort.toString();

  static const String login = "/login";
  static const String registration = "/registration";
  static const String allPlants = "/allPlants";

  static Future<void> httpPostRequest(String method) async {
    final response = await http.post(
      Uri.http(serverUrl, method),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
    );

    if (response.statusCode == 200) {
      switch (method) {
        case login:
          {}
          break;

        case registration:
          {}
          break;
      }

      // print(jsonDecode(response.body));
    }
  }

  static Future<void> httGetRequest(String method) async {
    final response = await http.get(
      Uri.http(serverUrl, method),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
    );

    if (response.statusCode == 200) {
      switch (method) {
        case allPlants:
          {}
          break;
      }

      // print(jsonDecode(response.body));
    }
  }
}
