import 'package:flutter/material.dart';

class StringListItem extends StatelessWidget {
  final String name;
  final bool isFavorite;
  final VoidCallback onTap;

  const StringListItem({
    super.key,
    required this.name,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(name),
      trailing: Icon(
        Icons.favorite,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
    );
  }
}
