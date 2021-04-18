import 'package:flutter/material.dart';
import 'package:plants_reminder/all_plants.dart';
import 'package:plants_reminder/profile.dart';
import 'package:plants_reminder/settings.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'check_connectivity.dart';
import 'utility.dart';
import 'main.dart';
import 'locale_database.dart';
import 'my_plants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final GlobalKey<MyPlantsState> _key = GlobalKey();
  List<Widget> _navigationItems;

  int _selectedIndex = 1;
  dynamic _choseValue;
  final dateController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void checkConnectivity() async {
  //   Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //     if (result == ConnectivityResult.none) {
  //       print("is not connected");
  //     } else {
  //       print("is connected");
  //     }
  //   });
  // }

  @override
  void initState() {
    CheckConnectivity.checkConnectivity();
    _navigationItems = <Widget>[
      MyPlants(key: _key),
      AllPlants(),
      Profile(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
  }

  callSetState() {
    setState(() {});
  }

  Future _newPlantPopup(BuildContext context, List<dynamic> plants) async {
    _choseValue = null;
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //your code dropdown button here
                  Text(
                    'Rastlina:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<dynamic>(
                    value: _choseValue,
                    items: plants.map(
                      (e) {
                        return DropdownMenuItem<dynamic>(
                          value: e,
                          child: Text(e['name'].toString()),
                        );
                      },
                    ).toList(),
                    onChanged: (dynamic value) {
                      //_choseValue = value;
                      setState(() {
                        //print(value);
                        _choseValue = value;
                      });
                    },
                  ),
                  Container(
                    child: Text(
                      'Dan zadnjega zalivanja',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    width: 100,
                    child: TextField(
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(hintText: 'Izberi datum'),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(3000));
                        dateController.text = date.toString().substring(0, 10);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: OutlinedButton(
                      onPressed: () async {
                        print(dateController.text);
                        Map<String, dynamic> map = {};
                        map['row_guid'] = await DatabaseHelper.getUserGuid();
                        map['plant_id'] = _choseValue['id'].toString();
                        map['last_watering'] = dateController.text.isEmpty
                            ? null
                            : dateController.text;
                        bool success = await Utility.httpPostRequest(
                            Utility.newUserPlant, map);

                        if (success) {
                          print("New plant added");
                          Navigator.pop(context);

                          setState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Roža dodana."),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          print("plant not added");

                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Roža ni bila dodana."),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        _key.currentState.getNewItemsFromParretn();
                      },
                      child: Text("Dodaj rožo"),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkConnectivity();
    return Scaffold(
        appBar: AppBar(
          title: Text('Plants reminder'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // print("Settings");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ),
          ],
        ),
        body: _navigationItems.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Theme.of(context).accentColor : Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail,
                  color: _selectedIndex == 1 ? Theme.of(context).accentColor : Colors.black),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 2 ? Theme.of(context).accentColor : Colors.black),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () async {
                  //print("Make a popup or newpage for adding new flower");
                  List<dynamic> plants =
                      await Utility.httpPostRequest(Utility.allPlants, null);

                  // List<DropdownMenuItem<String>> items =
                  //     plants.map((e) => e['latin_name']);
                  print(plants.length);
                  _newPlantPopup(context, plants);
                },
                child: new Icon(Icons.add),
              )
            : null);
  }
}
