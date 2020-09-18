import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

const appUrl = "https://streaming.afrimbox.com";
//const appImageUrl =
// "https://streaming.afrimbox.com/App/wp-content/uploads/2020/08/";
const moviesUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/movies?per_page=9';
const moviesByGenreUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/movies?per_page=9&genres=';
const genresUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/genres?post=';
const actorsUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/dtcast?post=';
const channelsUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/chaine_tv';
const searchUrl = "https://streaming.afrimbox.com/wp-json/wp/v2/search?&subtype=movies&search=";

const defaultChannel =
    'http://iptv.afrimbox.com:25461/movie/afrimbox/showtime/59.mp4';

Future<String> moviePoster(movie) async {
  String imgUrl = "";
  String mediaUrl = movie["_links"]["wp:featuredmedia"][0]["href"];
  try {
    await Dio().get(mediaUrl).then((res) {
      imgUrl = res.data["media_details"]["sizes"]["medium"]["source_url"];
    });
  } catch (e) {
    print("GET MOVIE MEDIA URL ERR ${e.toString()}");
  }

  return imgUrl;
}

const List<Map> category = [
  {'label': 'Tous les films', 'key': '0'},
  {'label': 'Populaires', 'key': '1'},
  {'label': 'Action', 'key': '49'},
  {'label': 'Animation', 'key': '79'},
  {'label': 'Aventure', 'key': '50'},
  {'label': 'Comédie', 'key': '51'},
  {'label': 'Crime', 'key': '320'},
  {'label': 'Documentaire', 'key': '1538'},
  {'label': 'Drame', 'key': '28'},
  {'label': 'Familial', 'key': '77'},
  {'label': 'Fantastique', 'key': '78'},
  {'label': 'Guerre', 'key': '614'},
  {'label': 'Histoire', 'key': '613'},
  {'label': 'Horreur', 'key': '14'},
  {'label': 'Musique', 'key': '421'},
  {'label': 'Mystère', 'key': '15'},
  {'label': 'Romance', 'key': '29'},
  {'label': 'Science-Fiction', 'key': '48'},
  {'label': 'Thriller', 'key': '16'}
  //{'label': 'Téléfilm', 'key': 3552},
];
