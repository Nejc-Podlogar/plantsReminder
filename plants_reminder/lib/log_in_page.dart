import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plants_reminder/register_page.dart';
import 'package:plants_reminder/main_page.dart';
import 'utility.dart';
import 'locale_database.dart';
import 'circular_progress_indicator.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailOrUsername = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false;

  void logIn() async {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => MainPage()));

    //return;
    if (emailOrUsername.text.isEmpty || password.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('NAPAKA'),
            content: const Text('Izpolniti je potrebno vsa polja!'),
            actions: [
              TextButton(
                child: Text('OK'),
                style: TextButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      String name = emailOrUsername.text;
      String pass = password.text;

      // TODO
      // try to log in here
      // on success redirect to mainpage
      //
      //
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> map = {};
      map['username'] = name;
      map['password'] = pass;
      dynamic res = await Utility.httpPostRequest(Utility.login, map);

      if (res != null) {
        if (res['success'] == true) {
          await DatabaseHelper.insertDB(res['row_guid']);
          print("login success: " + res['row_guid']);

          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          print("login unsecessful");
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Uporabnik ni najden."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Strežnik trenutno ne deluje."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return _isLoading
        ? CustomCircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 10) {
                if (Navigator.of(context).canPop() == true) {
                  Navigator.of(context).pop();
                }
              } else if (details.delta.dx < -10) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              }
            },
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 164, 252, 144),
                        Color.fromARGB(255, 0, 134, 0)
                      ]),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                "Plants Reminder",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: emailOrUsername,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 4),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.account_box_rounded,
                                      color: Colors.white,
                                    ),
                                    labelText: 'Uporabniško ime',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: password,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 4),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    labelText: 'Geslo',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                  //height: 50,
                                  child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "Še nimaš računa? Klikni tukaj ali podrsaj levo za registracijo!",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )),
                              Container(
                                margin: EdgeInsets.fromLTRB(100, 30, 100, 0),
                                child: ElevatedButton(
                                  onPressed: logIn,
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green[400],
                                      padding: EdgeInsets.all(10)),
                                  child: Text(
                                    "Prijava",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
