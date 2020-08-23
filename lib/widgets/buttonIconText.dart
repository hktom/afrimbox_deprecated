import 'package:flutter/material.dart';

class ButtonIconText extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String text;
  ButtonIconText(
      {Key key, @required this.icon, this.color, @required this.text})
      : super(key: key);

  @override
  _ButtonIconTextState createState() => _ButtonIconTextState();
}

class _ButtonIconTextState extends State<ButtonIconText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          widget.icon,
          color: widget.color == null ? Colors.grey : widget.color,
        ),
        SizedBox(height: 8),
        Text(
          widget.text,
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }
}
