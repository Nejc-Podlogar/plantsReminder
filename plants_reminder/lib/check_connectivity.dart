import 'dart:async';

import 'package:connectivity/connectivity.dart';

class CheckConnectivity {
  static bool connectivityStatus;

  static void checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print("is not connected");
        connectivityStatus = false;
      } else {
        print("is connected");
        connectivityStatus = true;
      }
    });
  }
}
