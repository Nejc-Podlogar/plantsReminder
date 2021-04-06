import 'package:flutter/material.dart';
import 'package:plants_reminder/circular_progress_indicator.dart';
import 'package:plants_reminder/utility.dart';

class AllPlants extends StatefulWidget {
  const AllPlants({Key key}) : super(key: key);

  @override
  State createState() => _AllPlants();
}

class _AllPlants extends State<AllPlants> {
  List<dynamic> _items;
  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    //Utility.httpGetRequest(Utility.allPlants);
    // _items = await Utility.httpGetRequest(Utility.allPlants);
    // print(_items.length);
    getItems();
    // setState(() {});
  }

  void getItems() async {
    _items = await Utility.httpGetRequest(Utility.allPlants);
    print(_items.length);

    await Future.delayed(const Duration(milliseconds: 5000));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(_items[index]["name"]);
            },
          )
        : CustomCircularProgressIndicator();
  }
}
