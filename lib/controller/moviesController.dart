import 'package:flutter/material.dart';
import '../components/customCard.dart';

class MoviesController {

  static String urlPoster="https://afrimbox.groukam.com/App/wp-content/uploads/2020/06/";

  static List myCard({int offset, double limit, data, double height, double width, bool overlay:false, bool hideTitle:false}){
    List<Widget> items = [];

    for (var i = offset; i < data.length; i++) {
      if(data.length<=0) {
    items.add(Text(''));
    }

      items.add(
        Container(
            width: width,
            child: CustomCard(
            overlay: overlay,
            height: height,
            id: data[i]['id'],
            title: !hideTitle?data[i]['title']['rendered']:'',
            image: urlPoster+data[i]['dt_poster'],
          ),
        )
      );

      if (i >= limit) break;
    }
    return items;
  }

  static List myChannels({int offset, double limit, data, double height, double width, bool overlay:false}){
    List<Widget> items = [];

    if(data.length<=0) {
    items.add(Text(''));
    }

    for (var i = offset; i < data.length; i++) {
      items.add(
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(horizontal:5),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
           ),
            width: width,
            child: CustomCard(
            height: height,
            id: data[i]['id'],
            //title: data[i]['title']['rendered'],
            image: data[i]['better_featured_image']['source_url'],
          ),
        )
      );

      if (i >= limit) break;
    }
    return items;
  }
}