import 'package:afrimbox/components/cardAvatar.dart';
import 'package:afrimbox/components/cardGenre.dart';
import 'package:afrimbox/components/placeHolders.dart';
import 'package:flutter/material.dart';
import '../components/customCard.dart';
import '../components/cardRounded.dart';
import 'package:afrimbox/helpers/tex.dart';

class MoviesController {
  // large card on the top
  static List myCard({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      items.add(PlaceHolders(type: 1));
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CustomCard(
        movie: data[i],
      ));

      if (i >= limit) break;
    }
    return items;
  }

  // channel card
  static List myChannels({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      for (var i = 0; i < 5; i++) {
        items.add(PlaceHolders(type: 2));
      }
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CardRounded(
        height: 100,
        width: 200,
        margin: EdgeInsets.symmetric(horizontal: 5),
        movie: data[i],
        isChannel: true,
      ));

      if (i >= limit) break;
    }
    return items;
  }

  //movies card
  static List poster({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      for (var i = 0; i < 5; i++) {
        items.add(PlaceHolders(type: 3));
      }
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CardRounded(
        height: 150,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 5),
        movie: data[i],
      ));

      if (i >= limit) break;
    }
    return items;
  }

  //channell posterGrid
  static List channelPosterGrid({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      for (var i = 0; i < 10; i++) {
        items.add(PlaceHolders(type: 4));
      }
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CardRounded(
        height: 150,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        movie: data[i],
        isChannel: true,
      ));

      if (i >= limit) break;
    }
    return items;
  }

  //movie posterGrid
  static List posterGrid({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      for (var i = 0; i < 10; i++) {
        items.add(PlaceHolders(type: 4));
      }
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CardRounded(
        height: 150,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        movie: data[i],
      ));

      if (i >= limit) break;
    }
    return items;
  }

  //list name in wrapper
  static List listName({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      items.add(Text(''));
    }

    for (var i = offset; i < data.length; i++) {
      items.add(Padding(
        padding: const EdgeInsets.all(4),
        child: Tex(content: data[i]['name']),
      ));
      if (i < data.length - 1)
        items.add(Tex(
          content: ", ",
        ));

      if (i >= limit) break;
    }
    return items;
  }

  static List avatar({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      items.add(Text(''));
    }

    for (var i = offset; i < data.length; i++) {
      items.add(CircularAvatar(
        data: data[i],
      ));

      if (i >= limit) break;
    }
    return items;
  }

  static List genres({
    int offset,
    double limit,
    data,
  }) {
    List<Widget> items = [];

    if (data.length <= 0) {
      items.add(Text(''));
    }

    for (var i = offset; i < data.length; i++) {
      items.add(Align(
        alignment: Alignment.centerLeft,
        child: CardGenre(
          data: data[i],
        ),
      ));

      if (i >= limit) break;
    }
    return items;
  }
}
