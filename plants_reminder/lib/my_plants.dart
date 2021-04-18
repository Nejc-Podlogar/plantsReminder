import 'package:flutter/material.dart';
import 'package:plants_reminder/locale_database.dart';
import 'package:plants_reminder/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:plants_reminder/utility.dart';
import 'package:plants_reminder/circular_progress_indicator.dart';
import 'dart:convert';
import 'main_page.dart';

import 'package:url_launcher/url_launcher.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({Key key}) : super(key: key);

  @override
  State createState() => MyPlantsState();
}

class MyPlantsState extends State<MyPlants> with TickerProviderStateMixin {
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

  @override
  void dispose() {
    _controller.dispose();
  }

  void getNewItemsFromParretn() async {
    setState(() {
      loading = true;
    });
    await getItems();
  }

  Future<void> getItems() async {
    Map<String, dynamic> map = {};
    // map['row_guid'] = "6fa459ea-ee8a-3ca4-894e-db77e160355e";
    map['row_guid'] = await DatabaseHelper.getUserGuid();
    _items = await Utility.httpPostRequest(Utility.allUserPlants, map);
    print(_items);

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      loading = false;
    });
  }

  void _launchWikipedia(String _url) async {
    await canLaunch(_url)
        ? await launch(_url)
        : throw 'Ne morem odpreti naslov $_url';
  }

  void _buildPopup(BuildContext context, dynamic plant) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.center,
          child: AlertDialog(
            title: Stack(
              children: <Widget>[
                Text(
                  plant["name"].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Positioned(
                  right: -20,
                  top: -18,
                  child: Container(
                    child: FlatButton(
                        onPressed: () async {
                          Map<String, dynamic> map = {};
                          map['id'] = plant['pu_id'].toString();

                          bool res = await Utility.httpPostRequest(
                              Utility.updateLastWatering, map);

                          if (res == true) {
                            Navigator.pop(context);

                            setState(() {
                              loading = true;
                            });
                            getItems();
                          }
                        },
                        child: Image(
                          image:
                              new AssetImage("assets/images/waterNoBack.png"),
                        )),
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(base64.decode(plant["slika"])),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Latinsko ime: ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                            text: plant["latin_name"],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16))
                      ])),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Interval zalivanja: ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                            text: plant["watering_period"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14))
                      ])),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Zadnje zalivanje: ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                            text: plant["watering_amount"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14))
                      ])),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      "Opis:",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(plant["description"]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: OutlinedButton(
                    child: Text("Wikipedija"),
                    onPressed: () => _launchWikipedia(plant["link_wiki"]),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> map = {};
                  map['id'] = plant['pu_id'].toString();
                  bool res = await Utility.httpPostRequest(
                      Utility.deleteUserPlant, map);

                  if (res == true) {
                    map = {};
                    map['row_guid'] = await DatabaseHelper.getUserGuid();
                    Navigator.pop(context);

                    setState(() {
                      loading = true;
                    });
                    getItems();
                  } else {
                    print("ni zbrisalo");
                  }
                },
                child: Text('Zbriši'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: Text('Zapri'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      if (_items == null) {
        //Funkcija se izvede za initState ter prepreči crash, ko se izvede klic build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Povezava na strežnik ni uspela."),
              duration: Duration(seconds: 3),
            ),
          );
        });
        return Column(children: [
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
        ]);
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TabBar(
              controller: _nestedTabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Theme.of(context).accentColor == Colors.green ? Colors.black : Colors.white,
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
              height: MediaQuery.of(context).size.height * 0.70,
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
                                      color: Theme.of(context).accentColor,
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
                              width:
                                  MediaQuery.of(context).size.width * 0.50 - 50,
                              height: 600,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    child: Image.memory(
                                        base64.decode(_items[index]["slika"]),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.50 -
                                                50),
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
        );
      }
    } else {
      return CustomCircularProgressIndicator();
    }
  }
}
