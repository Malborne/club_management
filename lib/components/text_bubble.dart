import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text;

  TextBubble({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.cyan[100],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            '$text',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
