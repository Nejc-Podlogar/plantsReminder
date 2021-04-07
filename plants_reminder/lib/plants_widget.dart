import 'package:flutter/material.dart';
import 'package:plants_reminder/plants_widget_detailed.dart';
import 'package:plants_reminder/utility.dart';

class PlantsWidget extends StatefulWidget {
  const PlantsWidget({Key key, this.plant}) : super(key: key);

  final dynamic plant;

  @override
  State createState() => _PlantsWidget();
}

class _PlantsWidget extends State<PlantsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantsWidgetDetailed(
              plant: widget.plant,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.local_florist),
              title: Text(widget.plant['name']),
              subtitle: Text(widget.plant['latin_name']),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(widget.plant['watering_amount'].toString() +
                      " ml" +
                      (widget.plant['watering_period'] == 1
                          ? " vsak dan."
                          : (" vsake " +
                              widget.plant['watering_period'].toString() +
                              " dni."))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
