import 'package:flutter/material.dart';
import 'package:plants_reminder/circular_progress_indicator.dart';
import 'package:plants_reminder/plants_widget.dart';
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
    _items = await Utility.httpPostRequest(Utility.allPlants, null);
    //print(_items.length);

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      loading = false;
    });
  }

  _buildElemnts() {
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
        return Container();
      } else if (_items.isEmpty) {
        return Text("Ni nobenih rož");
      } else {
        return ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: PlantsWidget(
                plant: _items[index],
              ),
            );
          },
        );
      }
    } else {
      return CustomCircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildElemnts();
  }
}
