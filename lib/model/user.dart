class User {
  final String name, profile, mobile, subscription, signMethod;
  final bool activate;
  final List favoritesMovies;
  final List favoritesChannels;

  User(
      {this.name,
      this.activate,
      this.favoritesChannels,
      this.favoritesMovies,
      this.mobile,
      this.profile,
      this.subscription,
      this.signMethod});

  Map toMap() {
    Map _user = {
      'name': this.name,
      'isProfileActive': this.activate,
      'favoritesChannels': this.favoritesChannels,
      'favoritesMovies': this.favoritesMovies,
      'mobile': this.mobile,
      'profile': this.profile,
      'subscription': this.subscription,
      'signMethod': this.signMethod,
      'created_at': '',
      'updated_at': ''
    };
    return _user;
  }
}
