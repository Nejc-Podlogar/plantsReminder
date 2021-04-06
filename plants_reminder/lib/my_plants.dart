import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flip_card/flip_card.dart';

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
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              calendarController: _controller),
          Text(
            "Moje rastline:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          FlipCard(
            front: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(210, 210, 210, 1),
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(127, 210, 210, 210),
              ),
              height: 300,
              width: dWidth * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("/logo/App_logoJPG.jpg", width: dWidth * 0.50),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                    child: Text(
                      "Marjetica",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                    child: Text(
                      "Zaliva se 1x na teden",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  )
                ],
              ),
            ),
            back: Container(
                color: Colors.blue, height: 300, width: dWidth * 0.50),
          ),
          // _navigationItems.elementAt(_selectedIndex),
        ],
      ),
    );
  }
}
