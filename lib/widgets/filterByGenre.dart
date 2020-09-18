import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/helpers/const.dart';

class FilterByGenre extends StatefulWidget {
  //final Function getMovies;
  //final Map currentGenre;
  FilterByGenre({Key key}) : super(key: key);

  @override
  _FilterByGenreState createState() => _FilterByGenreState();
}

class _FilterByGenreState extends State<FilterByGenre> {
  String dropdownValue = "All";
  bool showFilter = false;
  bool loadData = true;
  MoviesProvider model;

  @override
  void initState() {
    model = Provider.of<MoviesProvider>(context, listen: false);
    dropdownValue = model.currentGenre['label'];
    //getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !showFilter ? Colors.transparent : Theme.of(context).primaryColor,
      height: 60,
      width: !showFilter ? 60 : double.infinity,
      child: Stack(
        children: <Widget>[
          // Filter Genres
          showFilter
              ? ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.sortAmountDown,
                    color: Colors.white,
                  ),
                  title: _buttonDropdown(),
                  trailing: SizedBox(
                    height: 45,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                      onPressed: () {
                        this.setState(() => showFilter = false);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.times,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),

          // Button SHow Filter
          !showFilter
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16, top: 5),
                    child: SizedBox(
                      //height: 0,
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          this.setState(() => showFilter = true);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.slidersH,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buttonDropdown() {
    return DropdownButton<String>(
      dropdownColor: Theme.of(context).primaryColor,
      isExpanded: true,
      value: dropdownValue,
      icon: FaIcon(
        FontAwesomeIcons.chevronDown,
        color: Colors.white,
      ),
      iconSize: 20,
      elevation: 0,
      style: TextStyle(color: Colors.white),
      underline: Container(
        height: 0,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) async {
        model.setPendingByGenre();
        Map _currentCategory = mapGenreToKey(newValue);
        setState(() => dropdownValue = newValue);
        await model.getByGenre(_currentCategory);
        model.setCurrentGenre(_currentCategory);
      },
      items: category.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['label'],
          child: Tex(
            content: item['label'],
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }

  Map mapGenreToKey(String label) {
    var key;
    category.forEach((element) {
      if (element['label'] == label) {
        key = element;
      }
    });
    return key;
  }
}
