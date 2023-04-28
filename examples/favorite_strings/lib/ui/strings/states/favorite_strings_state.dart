import 'dart:async';

import 'package:favorite_strings/data/repositories/favoritable_string_repository.dart';
import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:washington/washington.dart';

class FavoriteStringsState extends UnitedState<List<FavoritableString>> {
  FavoriteStringsState(this.stringsRepository) : super([]) {
    _subscription = stringsRepository.watch().listen(_onNewData);
    setState(stringsRepository.read().where((s) => s.isFavorite).toList());
  }

  final FavoritableStringsRepository stringsRepository;
  StreamSubscription? _subscription;

  void _onNewData(List<FavoritableString> data) =>
      setState(data.where((s) => s.isFavorite).toList());

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
