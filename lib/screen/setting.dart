import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  UserProvider userProvider;
  bool themeIsLight = true;

  void checkCurrentTheme() {
    if (Theme.of(context).brightness == Brightness.dark) {
      themeIsLight = false;
    }
  }

  void setDark() {
    DynamicTheme.of(context).setBrightness(Brightness.dark);
    setState(() => themeIsLight = false);
  }

  void setLight() {
    DynamicTheme.of(context).setBrightness(Brightness.light);
    setState(() => themeIsLight = true);
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkCurrentTheme();
    return Scaffold(
      appBar: AppBar(
        title: Tex(
          content: "Paramètres",
          size: 'h4',
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: ListView(
          children: <Widget>[
            RowLayout.cards(children: <Widget>[
              Card(
                child: RowLayout.body(children: <Widget>[
                  RowItem.clickable(
                    'Profile',
                    'Modifier',
                    onTap: () => Get.toNamed('/profile'),
                  ),
                  RowItem.clickable(
                    'Thème',
                    themeIsLight ? 'Dark' : 'Light',
                    onTap: () {
                      if (themeIsLight) {
                        setDark();
                      } else {
                        setLight();
                      }
                    },
                  ),
                  RowItem.clickable(
                    'Notifications',
                    'Désactiver',
                    onTap: () {},
                  ),
                  RowItem.clickable(
                    'Mode Adult',
                    'Activer',
                    onTap: () {},
                  ),
                  Separator.divider(),
                  RowItem.clickable('Compte', 'Active'),
                ]),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
