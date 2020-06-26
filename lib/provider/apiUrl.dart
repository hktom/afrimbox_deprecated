class ApiUrl {
  static Map<String, String> apiurl = {
    'movies': 'http://afrimbox.groukam.com/wp-json/wp/v2/movies',
    'channels': 'http://afrimbox.groukam.com/wp-json/wp/v2/chaine_tv',
    'moviesBy': 'http://afrimbox.groukam.com/wp-json/wp/v2/movies?genres=',
    'genres': 'https://afrimbox.groukam.com/wp-json/wp/v2/genres?post=',
    'actors': 'https://afrimbox.groukam.com/wp-json/wp/v2/dtcast?post=',
    //'genres': 'http://afrimbox.groukam.com/wp-json/wp/v2/movies?genres=',
  };

  static Map<String, int> category = {
    'Action': 3295,
    'Animation': 3302,
    'Aventure': 3304,
    'Comédie': 3257,
    'Crime': 3318,
    'Documentaire': 3435,
    'Drame': 3273,
    'Familial': 3303,
    'Fantastique': 3527,
    'Guerre': 3692,
    'Histoire': 3386,
    'Horreur': 3291,
    'Musique': 3514,
    'Mystère': 3317,
    'Romance': 3332,
    'Science-Fiction': 3305,
    'Téléfilm': 3552,
    'Thriller': 3293,
  };

  static List<String> genres = [
    'Tout genres',
    'Action',
    'Animation',
    'Aventure',
    'Comédie',
    'Crime',
    'Documentaire',
    'Drame',
    'Familial',
    'Fantastique',
    'Guerre',
    'Histoire',
    'Horreur',
    'Musique',
    'Mystère',
    'Romance',
    'Science-Fiction',
    'Téléfilm',
    'Thriller'
  ];
}
