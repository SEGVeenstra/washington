import 'package:favorite_strings/data/data_sources/favoritable_strings_local_data_source.dart';
import 'package:favorite_strings/data/repositories/favoritable_string_repository.dart';
import 'package:favorite_strings/ui/favorite_strings_app.dart';
import 'package:favorite_strings/ui/strings/all_strings_state.dart';
import 'package:favorite_strings/ui/strings/favorite_strings_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  final stringsLocalDataSource = FavoritableStringsLocalDataSource();
  final stringsRepository = FavoritableStringsRepository(stringsLocalDataSource);

  GetIt.I.registerFactory<AllStringsState>(() => AllStringsState(stringsRepository));
  GetIt.I.registerFactory<FavoriteStringsState>(() => FavoriteStringsState(stringsRepository));

  runApp(const FavoriteStringsApp());
}
