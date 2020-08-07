import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/archive/channelArchive.dart';
import 'package:afrimbox/screen/archive/movieArchive.dart';
import 'package:afrimbox/screen/homeScreen.dart';
import 'package:afrimbox/screen/setting.dart';
import 'package:afrimbox/screen/subscription/subscription.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RouteStack extends StatefulWidget {
  @override
  _RouteStackState createState() => _RouteStackState();
}

class _RouteStackState extends State<RouteStack> {
  int _selectedIndex = 0;
  List<Widget> _screens = [
    HomeScreen(),
    MovieArchive(genre: 'All'),
    ChannelArchive(),
    Subscription(),
    Setting()
  ];

  PageController pageController = PageController();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/afrimbox-png.png',
          width: 100,
        ),
        actions: <Widget>[
          IconButton(
              icon: FaIcon(FontAwesomeIcons.userCircle),
              onPressed: () {
                Get.toNamed('/profile');
              })
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white60,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 18,
          unselectedFontSize: 10,
          selectedFontSize: 12,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home),
              title: Text('Accueil'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.film),
              title: Text('Film'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.tv),
              title: Text('Chaines'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.crown),
              title: Text('Abonnement'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cog),
              title: Text('Paramètres'),
            ),
          ]),
    );
  }
}