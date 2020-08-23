import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircularAvatar extends StatefulWidget {
  final Map data;

  CircularAvatar({Key key, this.data}) : super(key: key);

  @override
  _CircularAvatarState createState() => _CircularAvatarState();
}

class _CircularAvatarState extends State<CircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Container(
            width: 100,
          margin: EdgeInsets.symmetric(horizontal:5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            //FaIcon(FontAwesomeIcons.userCircle, size: 50,),
            Image.asset('assets/Portrait_Placeholder.png', height: 100, width: 100, fit: BoxFit.cover,),
            Tex(content: widget.data['name'], align: TextAlign.center, size: 'p',),
          ]
        )
      ),
    );
  }
}
