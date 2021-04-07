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
  static const String allUserPlants = "/allUserPlants";

  static Future<List<dynamic>> httpPostRequest(String method) async {
    final response = await http.post(
      Uri.http(serverUrl, method),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': 'test',
      }),
    );

    if (response.statusCode == 200) {
      switch (method) {
        case login:
          {}
          break;

        case registration:
          {}
          break;
        case allUserPlants:
          {
            Map<String, dynamic> res = jsonDecode(response.body);
            // if (res['success'] == true) {
            //   return res['plants'];
            // }
            return res['plants'];
          }
          break;
      }

      // print(jsonDecode(response.body));
    }
  }

  static Future<List<dynamic>> httpGetRequest(String method) async {
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
          {
            Map<String, dynamic> res = jsonDecode(response.body);
            // if (res['success'] == true) {
            //   return res['plants'];
            // }
            return res['plants'];
            // print(response.body);
          }
          break;
      }

      // print(jsonDecode(response.body));
    }
  }
}
