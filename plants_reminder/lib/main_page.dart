import 'package:flutter/material.dart';
import 'package:plants_reminder/all_plants.dart';
import 'package:plants_reminder/my_plants.dart';
import 'package:plants_reminder/profile.dart';
import 'package:plants_reminder/settings.dart';
import 'package:table_calendar/table_calendar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _navigationItems = <Widget>[
    MyPlants(),
    AllPlants(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
                }),
          ),
        ],
      ),
      body: Center(
        child: _navigationItems.elementAt(_selectedIndex),
      ),
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
    );
  }
}
