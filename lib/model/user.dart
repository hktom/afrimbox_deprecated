class User {
  final String name, userAvatar, phoneNumber, authMethod, email;
  final DateTime createdAt;
  final DateTime updateAt;
  final List favoritesMovies;
  final List favoritesChannels;
  final Map subscription;

  User(
      {this.name,
      this.email,
      this.createdAt,
      this.updateAt,
      this.phoneNumber,
      this.favoritesChannels,
      this.favoritesMovies,
      this.userAvatar,
      this.subscription,
      this.authMethod});

  Map toMap() {
    Map<String, dynamic> _user = {
      'name': this.name,
      'favoritesChannels': this.favoritesChannels,
      'favoritesMovies': this.favoritesMovies,
      'phoneNumber': this.phoneNumber,
      'userAvatar': this.userAvatar,
      'subscription': this.subscription,
      'authMethod': this.authMethod,
      'created_at': this.createdAt,
      'updated_at': this.updateAt
    };
    return _user;
  }
}
