import 'package:flutter/material.dart';
import 'package:plants_reminder/utility.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({Key key}) : super(key: key);

  @override
  State createState() => _CustomCircularProgressIndicator();
}

class _CustomCircularProgressIndicator
    extends State<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.2,
        child: CircularProgressIndicator(
          strokeWidth: 10.0,
        ),
      ),
    );
  }
}
