import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class Utility {
  // static const String serverIP = "192.168.1.194";
  static const String serverIP = "10.0.2.2";
  static const int serverPort = 5436;
  static String serverUrl = serverIP + ":" + serverPort.toString();

  static const String login = "/login";
  static const String registration = "/registration";
  static const String allPlants = "/allPlants";
  static const String allUserPlants = "/allUserPlants";
  static const String newUserPlant = "/newUserPlant";
  static const String updateLastWatering = "/updateLastWatering";
  static const String getProfileInfo = "/getProfileInfo";
  static const String deleteUserPlant = "/deleteUserPlant";

  static Future<dynamic> httpPostRequest(
      String method, Map<String, dynamic> jsonBody) async {
    final response = await http
        .post(
      Uri.http(serverUrl, method),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        // <String, dynamic>{
        //   'username': 'test',
        // },
        jsonBody,
      ),
    )
        .timeout(Duration(seconds: 3), onTimeout: () {
      print("Server not working");
      return null;
    });

    if (response == null) {
      return null;
    }

    if (response.statusCode == 200) {
      switch (method) {
        case login:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res;
          }
          break;

        case registration:
          {
            dynamic res = jsonDecode(response.body);

            return res;
          }
          break;
        case allUserPlants:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res['success'] == true ? res['plants'] : null;
          }
          break;

        case allPlants:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res['success'] == true ? res['plants'] : null;
          }
          break;

        case newUserPlant:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res['success'];
          }
          break;

        case updateLastWatering:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res['success'];
          }
          break;

        case getProfileInfo:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res;
          }
          break;

        case deleteUserPlant:
          {
            Map<String, dynamic> res = jsonDecode(response.body);

            return res['success'];
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
