import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/movie/movieArchive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:ouraganx/components/t.dart';
// import 'package:ouraganx/providers/audioProvider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'dart:io';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void toggleTheme() {
    //toggle the theme from dark to light
    Brightness currentBrightness = DynamicTheme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(currentBrightness == Brightness.light
        ? Brightness.dark
        : Brightness.light);
  }

  void checkTheme() {
    //toggle the theme from dark to light
    Brightness currentBrightness = DynamicTheme.of(context).brightness;
    setState(() {
      _dark = currentBrightness == Brightness.light ? false : true;
    });
  }

  bool _statusRadio = false;
  bool _dark = false;

  @override
  void initState() {
    checkTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.only(top: 40),
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Consumer<UserProvider>(
                builder: (context, model, child) => GestureDetector(
                  onTap: () => Get.toNamed('/profile'),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: model.currentUser[0]['photoUrl'] == null
                                  ? model.userDefaultPhoto
                                  : model.currentUser[0]['photoUrl'],
                              placeholder: (context, url) => Container(
                                color: Colors.grey,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Tex(
                            content: model.currentUser[0]['name'],
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.white,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                height: 40,
              ),
              _items(title: 'Accueil', icon: FontAwesomeIcons.home),
              _items(title: 'Films', icon: FontAwesomeIcons.film),
              //_items(title: 'Séries', icon: FontAwesomeIcons.boxOpen),
              _items(title: 'Chaines', icon: FontAwesomeIcons.tv),
              //_items(title: 'Connexion', icon: FontAwesomeIcons.userLock),
              _items(title: 'Paramètres', icon: FontAwesomeIcons.cog),
              _items(title: "S'abonner", icon: FontAwesomeIcons.crown),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Tex(
                  content: "Application",
                  color: Colors.grey,
                ),
              ),
              //_items(title: "Rate", icon: FontAwesomeIcons.star),
              _items(title: "Partager", icon: FontAwesomeIcons.shareAlt),
              _items(
                  title: "Rapport Bugs et Aide",
                  icon: FontAwesomeIcons.questionCircle),
              _items(
                  title: "Police de confidentialité",
                  icon: FontAwesomeIcons.lock),
              _items(title: "Quitter", icon: FontAwesomeIcons.signOutAlt),
            ],
          ),
        ),
      ),
    );
  }

  void _itemOnTap(title) {
    switch (title) {
      case 'Accueil':
        Get.offAllNamed('/home');
        break;
      case 'Chaines':
        Get.toNamed('/channelArchive');
        break;
      case 'Films':
        Get.to(MovieArchive(genre: "All"));
        break;
      case "S'abonner":
        Get.toNamed('/subscription');
        break;
      case "Paramètres":
        Get.toNamed('/setting');
        break;
      case 'Quitter':
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        break;
      default:
    }
  }

  ListTile _items({String title, IconData icon}) {
    return ListTile(
      dense: true,
      onTap: () {
        _itemOnTap(title);
      },
      leading: FaIcon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      title: Tex(
        content: title,
        color: Colors.white,
      ),
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
