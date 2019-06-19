import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {

  GameButton({@required this.onPressed,@required this.color,@required this.icon});

  final double minWidth = 100;
  final double height = 100;
  final GestureTapCallback onPressed;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: RaisedButton(
        onPressed: onPressed,
        color: color,
        child: Icon(icon, size: 50, color: Colors.white,),
      ),
    );
  }


}