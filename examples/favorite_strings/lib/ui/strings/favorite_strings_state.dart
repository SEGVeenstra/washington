import 'package:favorite_strings/data/repositories/favoritable_string_repository.dart';
import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:washington/washington.dart';

class FavoriteStringsState extends UnitedState<List<FavoritableString>> {
  FavoriteStringsState(this.stringsRepository) : super([]);

  final FavoritableStringsRepository stringsRepository;
}
