import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plants_reminder/log_in_page.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}

ThemeData basicTheme() {
  /*TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        title: base.title.copyWith(
          color: Colors.white,
        ),
        bodyText1: base.bodyText1.copyWith(
          color: Colors.white,
        ),
        body1: base.body1.copyWith(
          color: Colors.white,
        ));
  }*/

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.green,
    accentColor: Colors.green,
  );
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      title: 'Plants reminder',
      home: LogIn(),
      theme: theme.getTheme(),
    );
  }
}
