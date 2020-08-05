import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/helpers/const.dart';

class FilterByGenre extends StatefulWidget {
  //final Function getMovies;
  final String genre;
  FilterByGenre({Key key, this.genre}) : super(key: key);

  @override
  _FilterByGenreState createState() => _FilterByGenreState();
}

class _FilterByGenreState extends State<FilterByGenre> {
  String dropdownValue = "Tous";
  bool showFilter = false;
  bool loadData = true;
  MovieProvider model;

  Future<void> getMovies() async {
    await model.getByGenre(widget.genre);
  }

  @override
  void initState() {
    model = Provider.of<MovieProvider>(context, listen: false);
    dropdownValue = widget.genre;
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
        var key = mapGenreToKey(newValue);
        print(key);
        setState(() {
          dropdownValue = newValue;
        });
        await model.getByGenre(key);
      },
      items: category.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value['label'],
          child: Tex(
            content: value['label'],
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }

  String mapGenreToKey(String label) {
    var key;
    category.forEach((element) {
      if (element['label'] == label) {
        key = element['key'].toString();
      }
    });
    return key;
  }
}
