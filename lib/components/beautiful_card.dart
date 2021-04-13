import 'package:flutter/material.dart';

class BeautifulCard extends StatelessWidget {
  final int color;
  final String text;
  final Function onPressed;
  BeautifulCard(
      {@required this.color, @required this.text, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(8),
      onPressed: onPressed,
      fillColor: Color(this.color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: BoxConstraints.tightFor(
        width: 100,
        height: 100,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
