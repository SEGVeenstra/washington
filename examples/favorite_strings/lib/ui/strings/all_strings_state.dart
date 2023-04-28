import 'package:favorite_strings/data/repositories/favoritable_string_repository.dart';
import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:washington/washington.dart';

class AllStringsState extends UnitedState<List<FavoritableString>> {
  AllStringsState(this.stringsRepository) : super([]) {
    stringsRepository.read().then((value) => setState(value));
  }

  final FavoritableStringsRepository stringsRepository;
}
