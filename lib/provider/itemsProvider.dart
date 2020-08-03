import 'package:afrimbox/provider/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ItemsProvider extends ChangeNotifier {
  var items = {};
  List<String> genres = ApiUrl.genres;

  Future<void> getAllMovies() async {
    var response = await http.get(ApiUrl.apiurl['movies']);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      items['movies'] = jsonResponse;
      print("API REQUEST STATUS 200");
    } else {
      print("API REQUEST STATUS 404");
    }
  }

  Future<void> getMovieByGenre({String genre, bool MovieArchive: false}) async {
    var url = ApiUrl.apiurl['moviesBy'] + ApiUrl.category[genre].toString();
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      MovieArchive
          ? items['genreMovie'] = jsonResponse
          : items[genre] = jsonResponse;
      print("API REQUEST STATUS 200");
    } else {
      print("API REQUEST STATUS 404");
    }
  }

  Future<void> getAllChannels() async {
    var response = await http.get(ApiUrl.apiurl['channels']);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      items['channels'] = jsonResponse;
      print("API REQUEST STATUS 200");
    } else {
      print("API REQUEST STATUS 404");
    }
  }

  // Future<void> getItems({field, filter:'null'}) async {
  //   var url=filter=='null'?ApiUrl.apiurl[field]:ApiUrl.apiurl['moviesBy']+ApiUrl.category[filter].toString();
  //   print("URL $url");
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse = convert.jsonDecode(response.body);
  //     items[field]=jsonResponse;
  //     print("API REQUEST STATUS 200");
  //   } else {
  //     print("API REQUEST STATUS 404");
  //   }
  // }

  Future<List> req({field, int id}) async {
    var url = ApiUrl.apiurl[field] + id.toString();
    var data = [];
    print("URL $url");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      data = jsonResponse;
      return data;
    } else {
      return data;
    }
  }
}
