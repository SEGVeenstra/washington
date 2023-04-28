import 'dart:async';

import 'package:favorite_strings/data/repositories/favoritable_string_repository.dart';
import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:washington/washington.dart';

class FavoriteStringEvent {
  final String string;

  FavoriteStringEvent(this.string);
}

class UnfavoriteStringEvent {
  final String string;

  UnfavoriteStringEvent(this.string);
}

class OnUnfavoritedStringEvent {
  final String string;

  OnUnfavoritedStringEvent(this.string);
}

class AllStringsState extends UnitedState<List<FavoritableString>> {
  AllStringsState(this.stringsRepository) : super([]) {
    _subscription = stringsRepository.watch().listen(_onNewData);
    setState(stringsRepository.read());

    addHandler<FavoriteStringEvent>(_onFavoriteStringEvent);
    addHandler<UnfavoriteStringEvent>(_onUnfavoriteStringEvent);
  }

  final FavoritableStringsRepository stringsRepository;
  StreamSubscription? _subscription;

  Future<void> _onFavoriteStringEvent(FavoriteStringEvent event) async {
    stringsRepository.update(event.string, true);
  }

  Future<void> _onUnfavoriteStringEvent(UnfavoriteStringEvent event) async {
    stringsRepository.update(event.string, false);
    dispatch(OnUnfavoritedStringEvent(event.string));
  }

  void _onNewData(List<FavoritableString> data) => setState([...data]);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
