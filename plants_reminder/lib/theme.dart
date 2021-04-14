import 'package:flutter/material.dart';
import 'package:plants_reminder/main_page.dart';
import 'package:provider/provider.dart';
import 'package:plants_reminder/log_in_page.dart';
import 'circular_progress_indicator.dart';
import 'locale_database.dart';

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

// Widget _loginOrContinue() {
//   String neke;
//   DatabaseHelper.getUserGuid().then((String value) {
//     print(value);
//     neke = value;
//   });
//   print("neke" + neke);
//   return MainPage();
//   // print("User: " + neke);
//   // return value == "" ? LogIn() : MainPage();
// }

// class MaterialAppWithTheme extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<ThemeChanger>(context);
//     return MaterialApp(
//       title: 'Plants reminder',
//       home: _loginOrContinue(),
//       theme: theme.getTheme(),
//     );
//   }
// }
//

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      title: 'Plants reminder',
      home: LoginOrContinue(),
      theme: theme.getTheme(),
    );
  }
}

class LoginOrContinue extends StatefulWidget {
  const LoginOrContinue({Key key}) : super(key: key);

  @override
  State createState() => _LoginOrContinue();
}

class _LoginOrContinue extends State<LoginOrContinue> {
  Widget toLoad;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLogedIn();
  }

  checkIfLogedIn() async {
    toLoad = await DatabaseHelper.getUserGuid() == "" ? LogIn() : MainPage();
    setState(() {});
  }

  _buildElements() {
    if (toLoad == null) {
      return CustomCircularProgressIndicator();
    } else {
      return toLoad;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildElements();
  }
}
