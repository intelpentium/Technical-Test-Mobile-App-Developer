import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({required this.query, required this.onChanged, super.key});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        key: const ValueKey('search_input'),
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Search surah or reciter',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
