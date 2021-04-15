import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utility.dart';
import 'circular_progress_indicator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool _isLoading = false;

  void signUp() async {
    // register user here
    if (email.text.isEmpty ||
        username.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: const Text('Please fill in required fields!'),
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
    } else if (password.text != confirmPassword.text) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: const Text('Passwords must match!'),
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
      String str_email = email.text;
      String str_username = username.text;
      String str_pass = password.text;

      // TODO
      // try to register here
      // on success redirect to login page or mainpage

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> map = {};
      map['username'] = str_username;
      map['email'] = str_email;
      map['password'] = str_pass;
      dynamic res = await Utility.httpPostRequest(Utility.registration, map);
      if (res != null) {
        if (res['success'] == true) {
          Navigator.pop(context);

          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registracija uspela."),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['error']),
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
                  ])),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text("Create Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: email,
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
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  labelText: 'Email',
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
                                controller: username,
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
                                  labelText: 'Username',
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
                                  labelText: 'Password',
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
                                controller: confirmPassword,
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
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(100, 0, 100, 0),
                              child: ElevatedButton(
                                onPressed: signUp,
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green[400],
                                    padding: EdgeInsets.all(10)),
                                child: Text(
                                  "Sign Up",
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
            )),
          );
  }
}
