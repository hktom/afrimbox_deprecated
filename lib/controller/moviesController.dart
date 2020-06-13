import 'package:flutter/material.dart';
import '../components/customCard.dart';

class MoviesController {
  static List LargeCard({offset, limit, data}){
    List<Widget> items = [];

    for (var i = 0; i < data.length; i++) {
      items.add(
        CustomCard(
          id: data[i]['id'],
          title: data[i]['title']['rendered'],
          image: data[i],
        )
      );
    }
    return items;
  }
}