import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/genreScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ouraganx/components/t.dart';
// import 'package:ouraganx/providers/audioProvider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';

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
        width: MediaQuery.of(context).physicalDepth,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.only(top: 40),
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/Portrait_Placeholder.png',
                        height: 100, width: 100)),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                      onPressed: () {},
                      child: Tex(
                        content: "Se connecter à son compte",
                        color: Colors.white,
                      ))),
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
              _items(title: 'Accueil', icon: FontAwesomeIcons.store),
              _items(title: 'Films', icon: FontAwesomeIcons.film),
              _items(title: 'Séries', icon: FontAwesomeIcons.boxOpen),
              _items(title: 'Chaines', icon: FontAwesomeIcons.diceD20),
              _items(title: 'Connexion', icon: FontAwesomeIcons.userLock),
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
              _items(title: "Rate", icon: FontAwesomeIcons.star),
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

  void _itemOnTap(title){
    switch (title) {
      case 'Accueil':
      Get.offAllNamed('/home');
        break;
      case 'Films':
      Get.to(GenreScreen(genre:"Tout genres"));
        break;
      case 'Quitter':
      Provider.of<LoginProvider>(context, listen: false).signOut();
      Get.offAllNamed('/splash');
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
