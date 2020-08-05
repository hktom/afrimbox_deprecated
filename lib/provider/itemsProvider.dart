// import 'package:afrimbox/helpers/const.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

// class ItemsProvider extends ChangeNotifier {
//   var items = {};
//   //List<String> genres = ApiUrl.genres;

//   Future<void> getAllMovies() async {
//     var response = await http.get(moviesUrl);
//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body);
//       items['movies'] = jsonResponse;
//       print("API REQUEST STATUS 200");
//     } else {
//       print("API REQUEST STATUS 404");
//     }
//   }

//   Future<void> getMovieByGenre({String genre, bool movieArchive: false}) async {
//     var url = ApiUrl.apiurl['moviesBy'] + genre.toString();
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body);
//       movieArchive
//           ? items['genreMovie'] = jsonResponse
//           : items[genre] = jsonResponse;
//       print("API REQUEST STATUS 200");
//     } else {
//       print("API REQUEST STATUS 404");
//     }
//   }

//   Future<void> getAllChannels() async {
//     var response = await http.get(ApiUrl.apiurl['channels']);
//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body);
//       items['channels'] = jsonResponse;
//       print("API REQUEST STATUS 200");
//     } else {
//       print("API REQUEST STATUS 404");
//     }
//   }

//   Future<List> req({field, int id}) async {
//     var url = ApiUrl.apiurl[field] + id.toString();
//     var data = [];
//     print("URL $url");
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body);
//       data = jsonResponse;
//       return data;
//     } else {
//       return data;
//     }
//   }
// }
