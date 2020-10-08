import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:dio/dio.dart';

class ChannelProvider extends ChangeNotifier {
  var channels = [];
  var adultChannels = [];
  var loading = false;

  // get All channels
  Future<void> getChannels() async {
    channels = [];
    adultChannels = [];
    print("GET CHANNEL $channelsUrl &per_page=9");
    var response = await http.get(channelsUrl + '&per_page=70');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List _channels = jsonResponse;
      _filterChannel(_channels);
      print("CHANNEL API REQUEST STATUS 200");
    } else {
      print("CHANNEL API REQUEST STATUS 404");
    }
  }

  _filterChannel(_channels) {
    var _tempChannels = [];
    var _tempAdultChannels = [];

    _channels.forEach((channel) {
      channel["_embedded"]["wp:term"].forEach((terms) {
        terms.forEach((element) {
          if (element["name"] == "Adultes") {
            _tempAdultChannels.add(channel);
          } else {
            _tempChannels.add(channel);
          }
        });
      });
    });

    channels = _tempChannels;
    adultChannels = _tempAdultChannels;
  }

  Future<int> pagination({int page}) async {
    loading = true;
    Dio _dio = new Dio();
    int pages = page;
    String _url = "";
    String perpage = "&per_page=${page.toString()}";
    _url = channelsUrl + perpage;
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    await _dio.get(_url).then((res) {
      if (res.statusCode == 200) {
        _filterChannel(res.data);
        notifyListeners();
      }
      loading = false;
    }).catchError((err) {
      print("REQUEST Pagination Error ${err.toString()}");
      loading = false;
    });

    return pages;
  }
}
