import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:plants_reminder/utility.dart';
import 'package:plants_reminder/circular_progress_indicator.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({Key key}) : super(key: key);

  @override
  State createState() => _MyPlants();
}

class _MyPlants extends State<MyPlants> with TickerProviderStateMixin {
  CalendarController _controller;
  TabController _nestedTabController;
  List<dynamic> _items;
  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _nestedTabController = new TabController(length: 2, vsync: this);
    setState(() {
      loading = true;
    });
    getItems();
  }

  void getItems() async {
    _items = await Utility.httpPostRequest(Utility.allUserPlants);
    print(_items.length);

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      loading = false;
    });
  }

  void _buildPopup(BuildContext context, dynamic plant) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ListView(
              shrinkWrap: true,
              children: [
                AlertDialog(
                  title: Text(plant["name"]),
                  content: Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: 'Latinsko ime: ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            TextSpan(text: plant["latin_name"])
                          ])),
                      Container(
                        child: RichText(
                          text: TextSpan(text: 'Opis:'),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        child: Text('Zapri'))
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return loading == false
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TabBar(
                controller: _nestedTabController,
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black54,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    text: "Koledar",
                  ),
                  Tab(
                    text: "Moje rastline",
                  ),
                ],
              ),
              Container(
                height: screenHeight * 0.80,
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: TabBarView(
                  controller: _nestedTabController,
                  children: <Widget>[
                    Container(
                        child: TableCalendar(
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
                            calendarController: _controller)),
                    Container(
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        children: List.generate(_items.length, (index) {
                          return Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('card tapped');
                                _buildPopup(context, _items[index]);
                              },
                              child: Container(
                                width: screenWidth * 0.50 - 50,
                                height: 600,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: Image.asset(
                                          "/logo/App_logoJPG.jpg",
                                          width: screenWidth * 0.50 - 50),
                                    ),
                                    Container(
                                      height: 30,
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                      child: Text(
                                        _items[index]["name"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                      child: Text(
                                        _items[index]["watering_period"]
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : CustomCircularProgressIndicator();
  }
}
