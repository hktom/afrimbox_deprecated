import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class TileSwicth extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final void Function() onChanged;

  TileSwicth(
      {Key key,
      this.icon: Icons.brightness_6,
      this.title,
      this.subtitle: '',
      this.value,
      this.onChanged})
      : super(key: key);
  @override
  _TileSwicthState createState() => _TileSwicthState();
}

class _TileSwicthState extends State<TileSwicth> {
  @override
  Widget build(BuildContext context) {
    // return SwitchListTile(
    //   secondary: Icon(widget.icon, color: Theme.of(context).iconTheme.color),
    //   title: Text(widget.title),
    //   subtitle: Tex(content: widget.subtitle),
    //   value: widget.value,
    //   onChanged: (value) {
    //     widget.onChanged();
    //   },
    // );
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            Icon(widget.icon,
                color: Theme.of(context).iconTheme.color, size: 18),
            SizedBox(width: 10),
            Expanded(child: Text(widget.title)),
            Switch(
              value: widget.value,
              onChanged: (bool newValue) {
                widget.onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}
