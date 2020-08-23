import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/widgets/SettingListTile.dart';
import 'package:afrimbox/widgets/TileSwicth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:card_settings/card_settings.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 20),
        child: ListView(
          children: [_cardSetting(), SizedBox(height: 20), _cardSettingApp()],
        ),
      ),
    );
  }

  Widget _cardSetting() {
    return Card(
      child: Column(
        children: [
          SettingListTile(
            icon: Icons.person,
            title: "Profile",
            value: "Modifier",
            onTap: () {
              Get.toNamed('/profile');
            },
          ),
          Divider(),
          TileSwicth(
              title: "Theme",
              value: !themeIsLight,
              onChanged: () async {
                print("VALUE THEME ${!themeIsLight}");
                if (themeIsLight) {
                  await setDark();
                } else {
                  await setLight();
                }
              }),
          Divider(),
          TileSwicth(
              icon: Icons.notifications_active,
              title: "Notification",
              value: false,
              onChanged: () async {
                print("Active Notification");
              }),
          Divider(),
          TileSwicth(
              icon: Icons.beenhere,
              title: "Mode adult",
              value: false,
              onChanged: () async {
                print("Active mode adult");
              }),
        ],
      ),
    );
  }

  Widget _cardSettingApp() {
    return Card(
      child: Column(
        children: [
          SettingListTile(
            icon: Icons.share,
            title: "Partager",
            onTap: () {},
          ),
          Divider(),
          SettingListTile(
            icon: FontAwesomeIcons.questionCircle,
            title: "Rapport Bugs et Aide",
            onTap: () {},
          ),
          Divider(),
          SettingListTile(
            icon: FontAwesomeIcons.lock,
            title: "Politique de confidentialité",
            onTap: () {},
          ),
          Divider(),
          SettingListTile(
            icon: Icons.exit_to_app,
            title: "Quitter",
            onTap: () {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView(
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
        ]),

        //
        RowLayout.cards(children: <Widget>[
          Card(
            child: RowLayout.body(children: <Widget>[
              RowItem.clickable(
                'Apps',
                'Partager',
                onTap: () {},
              ),
              RowItem.clickable(
                'Rapport Bugs et Aide',
                'Envoyer',
                onTap: () async {},
              ),
              RowItem.clickable(
                'Police de confidentialité',
                'Lire',
                onTap: () {},
              ),
              Separator.divider(),
              RowItem.clickable(
                'Revenir plus tard',
                'Quitter',
                onTap: () {},
              ),
            ]),
          ),
        ]),
      ],
    );
  }
}
