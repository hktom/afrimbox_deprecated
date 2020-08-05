import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChannelProvider extends ChangeNotifier {
  var channels = [];

  // get All channels
  Future<void> get() async {
    var response = await http.get(channelsUrl);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      channels = jsonResponse;
      print("CHANNEL API REQUEST STATUS 200");
    } else {
      print("CHANNEL API REQUEST STATUS 404");
    }
  }
}
