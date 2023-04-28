class FavoritableString {
  final String string;
  final bool isFavorite;

  const FavoritableString({
    required this.string,
    this.isFavorite = false,
  });

  FavoritableString copyWith({bool? isFavorite}) => FavoritableString(
        string: string,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  String toString() {
    return 'FavoritableString(String $string, isFavorite: $isFavorite)';
  }
}
