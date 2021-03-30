import 'dart:html';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({Key key}) : super(key: key);

  @override
  State createState() => _MyPlants();
}

class _MyPlants extends State<MyPlants> {
  CalendarController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
              calendarStyle: CalendarStyle(
                  todayColor: Colors.green,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Colors.black,
                          style: BorderStyle.solid)),
                ),
                formatButtonTextStyle: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              calendarController: _controller)
          // _navigationItems.elementAt(_selectedIndex),
        ],
      ),
    );
  }
}
