import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class SettingListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final dynamic value;
  final void Function() onTap;

  SettingListTile(
      {Key key,
      this.icon: Icons.brightness_6,
      this.title,
      this.subtitle: '',
      this.value,
      this.onTap})
      : super(key: key);
  @override
  _SettingListTileState createState() => _SettingListTileState();
}

class _SettingListTileState extends State<SettingListTile> {
  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   isThreeLine: false,
    //   leading: Icon(widget.icon, color: Theme.of(context).iconTheme.color),
    //   title: Tex(content: widget.title),
    //   subtitle: Tex(content: widget.subtitle),
    //   trailing: Icon(Icons.arrow_forward_ios,
    //       color: Theme.of(context).iconTheme.color),
    //   onTap: widget.onTap,
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
            IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    color: Theme.of(context).iconTheme.color, size: 18),
                onPressed: widget.onTap),
          ],
        ),
      ),
    );
  }
}
