import 'package:afrimbox/provider/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ItemsProvider extends ChangeNotifier {
  List<Map> movies = [];

  Future<void> getMovies() async {
    var url = ApiUrl.apiurl['movies'];
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      this.movies = jsonResponse;

      print("API REQUEST WITH SUCCESS 200");
    } else {
      print("API REQUEST NOT WITH SUCCESS 200");
    }
  }
}
