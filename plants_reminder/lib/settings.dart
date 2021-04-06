import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State createState() => _Settings();
}

class _Settings extends State<Settings> {
  List<Widget> _widgets = <Widget>[
    GestureDetector(
      onTap: () {
        print("test");
      },
      child: ListTile(
        leading: Icon(Icons.info),
        title: Text("Test"),
      ),
    ),
    GestureDetector(
      onTap: () {
        print("test2");
      },
      child: ListTile(
        leading: Icon(Icons.info),
        title: Text("Test2"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants reminder'),
        actions: [],
      ),
      body: ListView.builder(
        itemCount: _widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_widgets[index]],
              ),
            ),
          );
        },
      ),
    );
  }
}
