// import 'dart:js';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plants_reminder/check_connectivity.dart';
import 'package:plants_reminder/main_page.dart';
import 'package:plants_reminder/theme.dart';
import 'utility.dart';
import 'package:plants_reminder/log_in_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(basicTheme()),
      child: new MaterialAppWithTheme(),
    );
  }
}
