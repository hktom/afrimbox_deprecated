import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/user/updateProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/userProvider.dart';

void sucessCallback(response, context) {
  print(response);
  Navigator.pop(context);
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) => SuccessScreen(
  //           amount: response['amount'],
  //           transactionId: response['transactionId'])),
  // );
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Map profile = {};
  //bool isProfileAlreadyExist = false;

  // get current user
  // void _getCurrentUser() {
  //   var currentUser =
  //       Provider.of<UserProvider>(context, listen: false).currentUser;

  //   var authUser = Provider.of<UserProvider>(context, listen: false).authUser;

  //   if (currentUser.contains(null)) {
  //     profile = authUser;
  //     profile['favoritesChannels'] = 0;
  //     profile['favoritesMovies'] = 0;
  //     profile['isProfileAlreadyExist'] = false;
  //   } else {
  //     print("DEBBUG $currentUser");
  //     profile = currentUser[0];
  //     if (!profile.containsKey('name')) profile['name'] = 'Ajouter Nom';
  //     if (!profile.containsKey('email')) profile['email'] = 'Ajouter Email';
  //     if (!profile.containsKey('phone')) profile['phone'] = 'Ajouter Télephone';
  //     //profile = authUser;
  //     isProfileAlreadyExist = true;
  //     profile['isProfileAlreadyExist'] = true;
  //   }
  // }

  @override
  void initState() {
    //_getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "Profile",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: ListTile(
                              trailing: IconButton(
                                  icon: Icon(Icons.edit), onPressed: null),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    imageUrl: model.currentUser[0]['photoUrl'],
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )),
                            ),
                          ),
                        ),
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
                      ],
                    )),

            RowLayout.cards(children: <Widget>[
              Card(
                child: RowLayout.body(children: <Widget>[
                  RowItem.text('Abonnement', '0 jour restant'),
                  RowItem.text('Films vu', '0'),
                  RowItem.text('Séries visionné', '0'),
                  RowItem.text('Chaine suivi', '0'),
                ]),
              ),
            ]),

            RowLayout.cards(children: <Widget>[
              Card(
                child: RowLayout.body(children: <Widget>[
                  RowItem.clickable(
                    "Films préferés",
                    "0",
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
                    onTap: () {
                      var authMethod =
                          Provider.of<UserProvider>(context, listen: false)
                              .currentUser[0]['email'];
                      Provider.of<UserProvider>(context, listen: false)
                          .signOut(authMethod);
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
}