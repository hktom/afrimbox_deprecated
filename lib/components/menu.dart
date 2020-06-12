import 'package:flutter/material.dart';
// import 'package:ouraganx/components/t.dart';
// import 'package:ouraganx/providers/audioProvider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  void toggleTheme() {
  //toggle the theme from dark to light
  Brightness currentBrightness=DynamicTheme.of(context).brightness;
  DynamicTheme.of(context).setBrightness(
      currentBrightness==Brightness.light
      ?Brightness.dark:Brightness.light);
}

  void checkTheme() {
  //toggle the theme from dark to light
  Brightness currentBrightness=DynamicTheme.of(context).brightness;
  setState(() {
    _dark=currentBrightness==Brightness.light
      ?false:true;
  });
}

  bool _statusRadio = false;
  bool _dark=false;

  @override
  void initState() {
    checkTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).physicalDepth,
        //color: Color.fromRGBO(21, 30, 43, 1),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.only(top: 40),
            children: <Widget>[
              
              SizedBox(
                height: 40,
              ),
              _items(
                  field: 'news',
                  title: 'film',
                  ),
              Divider(),
              _items(
                  field: 'news',
                  title: 'series',
                  ),
              Divider(),
              _items(
                  field: 'news',
                  title: 'documentaires',
                  ),
              Divider(),
              _items(
                  field: 'news',
                  title: 'Animation',
                  ),
              Divider(),
              
            ],
          ),
        ),
      ),
    );
  }

  ListTile _items({String field, String title}) {
    return ListTile(
      dense: true,
      onTap: () {
        Navigator.popAndPushNamed(context, '/menuPage',
            arguments: {'field': field, 'title': title});
      },
      // leading: FaIcon(
      //   icon,
      //   color: Colors.white,
      //   size: 20,
      // ),
      title: Text(title.toUpperCase()),
    );
  }

  SwitchListTile _itemSwitcher({String title, IconData icon}) {
    return SwitchListTile(
      dense: true,
      secondary: FaIcon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      title: Text(title.toUpperCase()),
      value: _dark,
      onChanged: (bool value) {
        toggleTheme();
        setState(() {
          _dark = value;
        });
      },
      
    );
  }
}
