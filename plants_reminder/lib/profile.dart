import 'dart:html';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //return ListView();
    return Container(
        //color: Colors.grey[800],
        child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  foregroundImage: NetworkImage(''), // TODO: lokalna slika pol
                  backgroundColor: Colors.blue,
                  radius: 40.0,
                ),
                SizedBox(height: 5.0),
                ElevatedButton(
                  child: Text("Click to add/change profile photo"),
                  onPressed: () {}, // TODO
                ),
                SizedBox(height: 30.0),
                Text(
                  "USERNAME:",
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.0),
                Text(
                  "plants_user",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Text(
                  "E-MAIL:",
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.0),
                Text(
                  "plants_user@gmail.com",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Text(
                  "NUMBER OF PLANTS:",
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.0),
                Text(
                  "5",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}
