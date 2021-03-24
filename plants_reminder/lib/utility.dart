import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class Utility {
  static String serverIP = "127.0.0.1";
  static int serverPort = 5436;
  static String serverUrl = serverIP + ":" + serverPort.toString();

  static String login = "/login";
  static String registration = "/registration";

  static Future<void> httpPostRequest() async {
    final response = await http.post(
      Uri.http(serverUrl, login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    }
  }
}
