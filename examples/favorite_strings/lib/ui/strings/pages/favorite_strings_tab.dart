import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:favorite_strings/ui/strings/states/all_strings_state.dart';
import 'package:favorite_strings/ui/strings/widgets/string_list_item.dart';
import 'package:flutter/material.dart';
import 'package:washington/washington.dart';

import '../states/favorite_strings_state.dart';

class FavoriteStringsTab extends StatelessWidget {
  const FavoriteStringsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder<FavoriteStringsState, List<FavoritableString>>.single(
      builder: (context, state) {
        if (state.value.isEmpty) {
          return const Center(child: Text('No favorites yet!'));
        }
        return ListView(
          children: state.value
              .map(
                (e) => StringListItem(
                  name: e.string,
                  isFavorite: e.isFavorite,
                  onTap: () =>
                      Washington.i.dispatch(UnfavoriteStringEvent(e.string)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
