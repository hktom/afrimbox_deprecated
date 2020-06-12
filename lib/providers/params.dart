import 'dart:convert';

class Params {
  static const username = "mechack";
  static const password = "Mesut@2020";
  static String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  static Map<dynamic, String> endpoints = {
    'movies': 'https://afrimbox.groukam.com/wp-json/wp/v2/movies',
  };
}
