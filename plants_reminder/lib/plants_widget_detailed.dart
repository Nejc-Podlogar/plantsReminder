import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plants_reminder/utility.dart';

class PlantsWidgetDetailed extends StatefulWidget {
  const PlantsWidgetDetailed({Key key, this.plant}) : super(key: key);

  final dynamic plant;

  @override
  State createState() => _PlantsWidgetDetailed();
}

class _PlantsWidgetDetailed extends State<PlantsWidgetDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(widget.plant['name']),
            Text(widget.plant['latin_name']),
            //Image.memory(base64.decode(widget.plant['image'].toString()))
          ],
        ),
      ),
    );
  }
}
