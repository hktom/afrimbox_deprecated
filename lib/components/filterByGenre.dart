import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:provider/provider.dart';

class FilterByGenre extends StatefulWidget {
  final Function getMovies;
  FilterByGenre({Key key, @required this.getMovies}) : super(key: key);

  @override
  _FilterByGenreState createState() => _FilterByGenreState();
}

class _FilterByGenreState extends State<FilterByGenre> {
  String dropdownValue = "Tout genres";
  bool showFilter = false;
  bool loadData = true;

  Future<void> getMovies(genre) async {
    print("LOAD MOVIE BY $genre");
    setState(() {
      loadData = false;
    });

    if (genre == "Tout genres") {
      await Provider.of<ItemsProvider>(context, listen: false).getAllMovies();
    } else {
      await Provider.of<ItemsProvider>(context, listen: false)
          .getMovieByGenre(genre: genre, MovieArchive: true);
    }

    setState(() {
      loadData = true;
    });
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
        setState(() {
          dropdownValue = newValue;
        });
        //await getMovies(newValue);
        await widget.getMovies(newValue);
      },
      items: Provider.of<ItemsProvider>(context, listen: false)
          .genres
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Tex(
            content: value,
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }
}
