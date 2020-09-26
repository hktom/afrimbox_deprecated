import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChannelProvider extends ChangeNotifier {
  var channels = [];
  var adultChannels = [];

  // get All channels
  Future<void> getChannels() async {
    channels = [];
    adultChannels = [];
    print("GET CHANNEL $channelsUrl");
    var response = await http.get(channelsUrl);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List _channels = jsonResponse;
      _channels.forEach((channel) {
        channel["_embedded"]["wp:term"].forEach((terms) {
          terms.forEach((element) {
            if (element["name"] == "Adultes") {
              adultChannels.add(channel);
            } else {
              channels.add(channel);
            }
          });
        });
      });
      print("CHANNEL API REQUEST STATUS 200");
    } else {
      print("CHANNEL API REQUEST STATUS 404");
    }
  }
}
