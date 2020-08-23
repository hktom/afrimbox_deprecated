const appUrl = "https://streaming.afrimbox.com";
const appImageUrl =
    "https://streaming.afrimbox.com/App/wp-content/uploads/2020/08/";
const moviesUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/movies';
const moviesByGenreUrl =
    'https://streaming.afrimbox.com/wp-json/wp/v2/movies?genres=';
const genresUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/genres?post=';
const actorsUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/dtcast?post=';
const channelsUrl = 'https://streaming.afrimbox.com/wp-json/wp/v2/chaine_tv';

const defaultChannel =
    'http://iptv.afrimbox.com:25461/movie/afrimbox/showtime/59.mp4';
//'http://zmky-nextcloud.sandslash.seedbox.link/s/esm5JcjaGRo7eot/download';
//http://iptv.afrimbox.com:25461/movie/Afrimbox/\$2y\$10\$Gs/59.mp4

const List<Map> category = [
  {'label': 'All', 'key': 0},
  {'label': 'Popular', 'key': 1},
  {'label': 'Action', 'key': 3295},
  {'label': 'Animation', 'key': 3302},
  {'label': 'Aventure', 'key': 3304},
  {'label': 'Comédie', 'key': 3257},
  {'label': 'Crime', 'key': 3318},
  {'label': 'Documentaire', 'key': 3435},
  {'label': 'Drame', 'key': 3273},
  {'label': 'Familial', 'key': 3303},
  {'label': 'Fantastique', 'key': 3527},
  {'label': 'Guerre', 'key': 3692},
  {'label': 'Histoire', 'key': 3386},
  {'label': 'Horreur', 'key': 3291},
  {'label': 'Musique', 'key': 3514},
  {'label': 'Mystère', 'key': 3317},
  {'label': 'Romance', 'key': 3332},
  {'label': 'Science-Fiction', 'key': 3305},
  {'label': 'Téléfilm', 'key': 3552},
  {'label': 'Thriller', 'key': 3293}
];
