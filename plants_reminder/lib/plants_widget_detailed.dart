import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plants_reminder/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantsWidgetDetailed extends StatefulWidget {
  const PlantsWidgetDetailed({Key key, this.plant}) : super(key: key);

  final dynamic plant;

  @override
  State createState() => _PlantsWidgetDetailed();
}

class _PlantsWidgetDetailed extends State<PlantsWidgetDetailed> {
  _launchWikiPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.plant['name'],
                ),
              ),
              Text(
                widget.plant['latin_name'],
              ),
              Image.memory(
                Base64Decoder().convert(
                  widget.plant['slika'].toString(),
                ),
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Text(
                widget.plant['description'].toString(),
              ),
              TextButton(
                onPressed: () {
                  _launchWikiPage(widget.plant['link_wiki'].toString());
                },
                child: Text("Wikipedia"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
