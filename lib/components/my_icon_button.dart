import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;
  final Color iconColor;
  final double size;
  final double buttonSize;
  final ShapeBorder shape;
  MyIconButton(
      {@required this.icon,
      @required this.onPressed,
      @required this.color,
      @required this.iconColor,
      @required this.size,
      this.buttonSize = 56,
      @required this.shape});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: this.onPressed,
      shape: this.shape,
      elevation: 0,
      child: Icon(
        this.icon,
        size: this.size,
        color: iconColor,
      ),
      fillColor: this.color,
      constraints: BoxConstraints.tightFor(
        width: buttonSize,
        height: buttonSize,
      ),
    );
  }
}
