const appUrl = "https://streaming.afrimbox.com";

const moviesUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/movies?_embed=wp:featuredmedia,wp:term';
const moviesByGenreUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/movies?_embed=wp:featuredmedia,wp:term&per_page=9&genres=';

const channelsUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/chaine_tv?_embed=wp:term&per_page=100';
const searchUrl =
    "https://streaming.afrimbox.com/wp-json/wp/v2/search?&subtype=movies&search=";

const defaultChannel =
    'http://iptv.afrimbox.com:25461/movie/afrimbox/showtime/59.mp4';

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
