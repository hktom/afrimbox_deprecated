import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:connectivity/connectivity.dart';
import 'params.dart';

class MoviesProvider extends ChangeNotifier {
  Map movies = {};
  Map<String, int> status = {};
  var network_status;

  // Future<void> checkSNetworkStatus()async{
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   this.network_status=connectivityResult;
  // }

  Future<void> getMovies(field) async {
    try {
      this.status.remove(field);
      print("get $field movies");
      var url = Params.endpoints[field];
      var res = await http.get(url,
          headers: <String, String>{'authorization': Params.basicAuth});
      this.movies[field] = json.decode(res.body);
      this.status[field] = 200;
      print("$field DATA SIZE ${movies[field].length}");
    } catch (e) {
      this.status[field] = 404;
      print("ERROR $e");
    }
  }
}
