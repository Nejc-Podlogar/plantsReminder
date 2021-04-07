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
    return SingleChildScrollView(
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
          Container(
            child: Text("Pozdrav"),
          )
          // _navigationItems.elementAt(_selectedIndex),
        ],
      ),
    );
  }
}

Widget _buildGrid(double dWidth) => GridView.extent(
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(5, dWidth),
    );

List<Container> _buildGridTileList(int count, double dWidth) => List.generate(
    count,
    (i) => Container(
          child: Text("Test"),
        ));
