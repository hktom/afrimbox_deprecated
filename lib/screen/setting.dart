import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  bool themeIsLight = true;
  SharedPreferences prefs;

  Future<void> checkCurrentTheme() async {
    prefs = await SharedPreferences.getInstance();
    bool _currentTheme = prefs.getBool('themeIsLight') != null
        ? prefs.getBool('themeIsLight')
        : true;
    setState(() {
      themeIsLight = _currentTheme;
    });
  }

  Future<void> setDark() async {
    await DynamicTheme.of(context).setBrightness(Brightness.dark);
    prefs.setBool('themeIsLight', false);
    setState(() => themeIsLight = false);
  }

  Future<void> setLight() async {
    await DynamicTheme.of(context).setBrightness(Brightness.light);
    prefs.setBool('themeIsLight', true);
    setState(() => themeIsLight = true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    checkCurrentTheme();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
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
                    onTap: () async {
                      if (themeIsLight) {
                        await setDark();
                      } else {
                        await setLight();
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
