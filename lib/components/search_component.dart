import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const MySearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Search notes',
        ),
        onChanged: onChanged,
      ),
    );
  }
}
