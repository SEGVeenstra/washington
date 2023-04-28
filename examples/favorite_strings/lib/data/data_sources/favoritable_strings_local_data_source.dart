import '../../domain/entities/favoritable_string.dart';

class FavoritableStringsLocalDataSource {
  final List<FavoritableString> _favoritables = [
    const FavoritableString(string: 'One'),
    const FavoritableString(string: 'Two'),
    const FavoritableString(string: 'Three'),
    const FavoritableString(string: 'Four'),
    const FavoritableString(string: 'Five'),
  ];

  List<FavoritableString> read() {
    return _favoritables;
  }

  void update(String title, bool fav) {
    final index = _favoritables.indexWhere((f) => f.string == title);
    final removed = _favoritables[index];
    if (removed.isFavorite != fav) {
      _favoritables[index] = FavoritableString(string: removed.string, isFavorite: fav);
    }
  }
}
