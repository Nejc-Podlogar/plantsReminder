import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plants_reminder/changePassword.dart';
import 'package:plants_reminder/locale_database.dart';
import 'package:plants_reminder/log_in_page.dart';
import 'package:plants_reminder/main.dart';
import 'package:provider/provider.dart';
import 'package:plants_reminder/theme.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool boolWateringNotifications = true;
  bool boolNewsForYou = true;
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            //Change password
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),

            //Change theme
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Change Theme"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FlatButton(
                                child: Text('Dark Theme'),
                                onPressed: () =>
                                    _themeChanger.setTheme(ThemeData.dark())),
                            FlatButton(
                                child: Text('Light Theme'),
                                onPressed: () =>
                                    _themeChanger.setTheme(basicTheme())),
                          ],
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close")),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Theme",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),

            //Privacy and security
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Privacy and Security"),
                        content: SingleChildScrollView(
                          child: Text(
                              "PRIVACY NOTICE\nLast updated April 12, 2021\n\nThan you for choosing to ba part of our community at Plants reminder co. \"Company\", \"we\", \"us\"). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at support@plantsreminder.com.\n\nWhen you use our mobile application, as the case may be (the \"App\") and more genereally, use any of our services(the \"Services\", which include the App) ,we appreciate that you are trusting us with your personal information. We take privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Services immediately.\n\nThis privacy notice applies to all information collected through our Services(which, as described above, includesout App), as well as, any related services, sales, marketing and events. \n\nPlease read this privacy notice carefully as it will help you understand what we do with the information that we collect."),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close")),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Privacy and Security",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),

            //notification settings
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),

            //Plant news
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Plant News",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: boolNewsForYou,
                    onChanged: (value) {
                      setState(() {
                        boolNewsForYou = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            //Watering notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Watering Notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: boolWateringNotifications,
                    onChanged: (value) {
                      setState(() {
                        boolWateringNotifications = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            TextButton(
              onPressed: () async {
                //DatabaseHelper.insertDB("Test");
                //print("Guid v bazi: " + await DatabaseHelper.getUserGuid());
                await DatabaseHelper.deleteUserInfo();
                // print("Guid v bazi: " + await DatabaseHelper.getUserGuid());
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
