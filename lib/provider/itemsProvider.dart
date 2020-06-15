import 'package:afrimbox/provider/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ItemsProvider extends ChangeNotifier {
  var items = {};

  Future<void> getItems({field, filter:'null'}) async {
    var url=filter=='null'?ApiUrl.apiurl[field]:ApiUrl.apiurl['moviesBy']+ApiUrl.category[filter].toString();
    print("URL $url");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      items[field]=jsonResponse;
      
      print("API REQUEST STATUS 200");
    } else {
      print("API REQUEST STATUS 404");
    }
  }
}
