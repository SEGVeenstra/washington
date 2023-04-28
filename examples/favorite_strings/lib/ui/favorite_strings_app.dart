import 'package:favorite_strings/ui/strings/pages/strings_page.dart';
import 'package:flutter/material.dart';

class FavoriteStringsApp extends StatelessWidget {
  const FavoriteStringsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Favorite Strings',
      home: StringsPage(),
    );
  }
}
