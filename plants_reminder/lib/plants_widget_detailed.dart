import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plants_reminder/utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class PlantsWidgetDetailed extends StatefulWidget {
  const PlantsWidgetDetailed({Key key, this.plant}) : super(key: key);

  final dynamic plant;

  @override
  State createState() => _PlantsWidgetDetailed();
}

class _PlantsWidgetDetailed extends State<PlantsWidgetDetailed> {
  Future<void> _launchWikiPage(String url) async {
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
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.plant['name'],
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.plant['latin_name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.memory(
                  Base64Decoder().convert(
                    widget.plant['slika'].toString(),
                  ),
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.plant['description'].toString(),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _launchWikiPage(widget.plant['link_wiki'].toString());
              },
              child: Text("Wikipedia"),
            ),
          ],
        ),
      ),
    );
  }
}
