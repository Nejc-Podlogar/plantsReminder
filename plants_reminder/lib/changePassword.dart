import 'package:flutter/material.dart';
import 'package:plants_reminder/locale_database.dart';
import 'package:plants_reminder/utility.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  State createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  String currPass;
  String newPass;
  String newPassConf;

  @override
  Widget build(BuildContext context) {
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
        child: ListView(children: [
          Text(
            "Change Password",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Current Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(), /*hintText: "Current Password"*/
            ),
            style: TextStyle(fontSize: 20),
            onChanged: (text) => setState(() {
              currPass = text;
            }),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "New Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20),
            onChanged: (text) => setState(() {
              newPass = text;
            }),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Confirm Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20),
            onChanged: (text) => setState(() {
              newPassConf = text;
            }),
          ),
          SizedBox(
            height: 5,
          ),
          OutlinedButton(
            // color: Theme.of(context).accentColor,
            style: OutlinedButton.styleFrom(
                primary: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Theme.of(context).accentColor),
            onPressed: () async {
              submitPasswordChange();
            },
            child: Text("Change password"),
            // textColor: Theme.of(context).scaffoldBackgroundColor,
          )
        ]),
      ),
    );
  }

  submitPasswordChange() async {
    Map<String, dynamic> map = {};
    Map<String, dynamic> result = {};

    map['row_guid'] = await DatabaseHelper.getUserGuid();
    map['old_password'] = currPass;
    map['new_password'] = newPass;
    map['confirm_password'] = newPassConf;

    result = await Utility.httpPostRequest(Utility.changePassword, map);

    return result['success'] == true
        ? showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Shranjevanje novega gesla'),
                  content: Text('Shranjevanje je uspešno'),
                  actions: <Widget>[
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('OK'))
                  ],
                ))
        : showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Shranjevanje novega gesla NEUSPEŠNO'),
                  content: Text(result['reason']),
                  actions: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
  }
}
// AlertDialog(
//       title: Text("Working on it"),
//       content: Column(
//         children: [Text("working on it")],
//       ),
//       actions: [
//         FlatButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text("Close")),
//       ],
//     );
