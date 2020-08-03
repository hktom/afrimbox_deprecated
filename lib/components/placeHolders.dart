import 'package:flutter/material.dart';

class PlaceHolders extends StatelessWidget {
  final int type;
  PlaceHolders({Key key, @required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case 1:
        return card();
        break;

      case 2:
        return cardHorizontal();
        break;

      case 3:
        return cardRounded();
        break;

      case 4:
        return cardGridRounded();
        break;

      default:
        return card();
    }
  }

  Widget card() {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.grey[300],
    );
  }

  Widget cardHorizontal() {
    return Container(
      height: 100,
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(color: Colors.grey[300]),
      ),
    );
  }

  Widget cardRounded() {
    return Container(
      height: 150,
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(color: Colors.grey[350]),
      ),
    );
  }

  Widget cardGridRounded() {
    return Container(
      height: 150,
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(color: Colors.grey[350]),
      ),
    );
  }
}
