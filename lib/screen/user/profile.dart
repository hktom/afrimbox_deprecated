import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/user/updateProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProvider userProvider;
  SharedPreferences prefs;

  Future<void> renitStateTheme() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.getBool('themeIsLight')) {
      prefs.setBool('themeIsLight', true);
      await DynamicTheme.of(context).setBrightness(Brightness.light);
    }
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Tex(
          content: "Profile",
          color: Colors.white,
          size: 'h4',
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: ListView(
          children: <Widget>[
            Consumer<UserProvider>(
                builder: (context, model, child) => Column(
                      children: <Widget>[
                        //_cardUserAvatar()
                        RowLayout.cards(children: <Widget>[
                          Card(
                            child: RowLayout.body(children: <Widget>[
                              RowItem.clickable(
                                'Nom',
                                model.currentUser[0]['name'],
                                onTap: () => Get.to(UpdateProfile(
                                  typeField: 1,
                                  defaultValue: model.currentUser[0]['name'],
                                  profile: model.currentUser[0],
                                )),
                              ),
                              RowItem.text(
                                'Email',
                                model.currentUser[0]['email'],
                              ),
                              RowItem.text(
                                'Télephone',
                                model.currentUser[0]['phone'],
                              ),
                              Separator.divider(),
                              RowItem.text('Compte status', 'Active'),
                            ]),
                          ),
                        ]),
                        RowLayout.cards(children: <Widget>[
                          Card(
                            child: RowLayout.body(children: <Widget>[
                              RowItem.text(
                                  'Abonnement',
                                  model.subscriptionRemainDays().toString() +
                                      ' jour restant'),
                              RowItem.text('Films vu', '0'),
                              RowItem.text('Séries visionné', '0'),
                              RowItem.text('Chaine suivi', '0'),
                            ]),
                          ),
                        ]),
                      ],
                    )),

            RowLayout.cards(children: <Widget>[
              Card(
                child: RowLayout.body(children: <Widget>[
                  RowItem.clickable(
                    "Films préferés",
                    userProvider.currentUser[0]['favoriteMovies'] != null
                        ? userProvider.currentUser[0]['favoriteMovies'].length
                            .toString()
                        : '0',
                    onTap: () {},
                  ),
                  RowItem.clickable(
                    "Chaines préferées",
                    "0",
                    onTap: () {},
                  ),
                  RowItem.clickable(
                    "Séries préferés",
                    "0",
                    onTap: () {},
                  ),
                ]),
              ),
            ]),

            RowLayout.cards(children: <Widget>[
              Card(
                child: RowLayout.body(children: <Widget>[
                  RowItem.clickable(
                    "Mon profile",
                    "Se deconnecter",
                    onTap: () async {
                      await renitStateTheme();
                      await Provider.of<UserProvider>(context, listen: false)
                          .signOut();
                      Get.offAllNamed('/splash');
                    },
                  ),
                ]),
              ),
            ]),

            // RaisedButton(
            //   child: Text('PAY NOW'),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => kkiapay),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _cardUserAvatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: ListTile(
          trailing: IconButton(icon: Icon(Icons.edit), onPressed: null),
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageUrl: userProvider.currentUser[0]['photoUrl'] == null
                    ? userProvider.userDefaultPhoto
                    : userProvider.currentUser[0]['photoUrl'],
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
        ),
      ),
    );
  }
}
