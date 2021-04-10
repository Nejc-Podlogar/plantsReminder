import 'package:flutter/material.dart';
import 'package:plants_reminder/all_plants.dart';
import 'package:plants_reminder/my_plants.dart';
import 'package:plants_reminder/profile.dart';
import 'package:plants_reminder/settings.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'check_connectivity.dart';
import 'utility.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedIndex = 1;
  dynamic _choseValue;

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
    super.initState();
  }

  static const List<Widget> _navigationItems = <Widget>[
    MyPlants(),
    AllPlants(),
    Profile(),
  ];

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
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  TextButton(
                      onPressed: () async {
                        Map<String, dynamic> map = {};
                        map['row_guid'] =
                            "6fa459ea-ee8a-3ca4-894e-db77e160355e";
                        map['plant_id'] = _choseValue['id'].toString();
                        await Utility.httpPostRequest(
                            Utility.newUserPlant, map);
                      },
                      child: Text("Dodaj rožo"))
                ],
              );
            },
          ),
        );
      },
    );
    // return await showDialog<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //           // width: MediaQuery.of(context).size.width,
    //           // height: MediaQuery.of(context).size.height,
    //           content: StatefulBuilder(
    //         builder: (BuildContext context) {
    //           DropdownButton<dynamic>(
    //             value: _choseValue,
    //             items: plants.map(
    //               (e) {
    //                 return DropdownMenuItem<dynamic>(
    //                   value: e,
    //                   child: Text(e['name'].toString()),
    //                 );
    //               },
    //             ).toList(),
    //             onChanged: (dynamic value) {
    //               _choseValue = value;
    //               // setState(() {
    //               //   //print(value);
    //               //   _choseValue = value;
    //               // });
    //             },
    //           );
    //         },
    //       ));
    //     });
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
                  color: _selectedIndex == 0 ? Colors.blue : Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.black),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black),
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
