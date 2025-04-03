import 'package:flutter/material.dart';

class MilestoneTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const MilestoneTile({super.key, required this.title, required this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      onTap: onTap,
    );
  }
}
