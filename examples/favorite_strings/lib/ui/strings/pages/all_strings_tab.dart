import 'package:favorite_strings/domain/entities/favoritable_string.dart';
import 'package:favorite_strings/ui/strings/states/all_strings_state.dart';
import 'package:favorite_strings/ui/strings/states/favorite_strings_state.dart';
import 'package:favorite_strings/ui/strings/widgets/string_list_item.dart';
import 'package:flutter/material.dart';
import 'package:washington/washington.dart';

class AllStringsTab extends StatelessWidget {
  const AllStringsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder<AllStringsState, List<FavoritableString>>.single(
      builder: (context, state) {
        return ListView(
          children: state.value
              .map(
                (e) => StringListItem(
                  name: e.string,
                  isFavorite: e.isFavorite,
                  onTap: () => e.isFavorite
                      ? Washington.i.dispatch(UnfavoriteStringEvent(e.string))
                      : Washington.i.dispatch(FavoriteStringEvent(e.string)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
