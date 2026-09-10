import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
   required this.searchController,
    required this.onChanged,
    required this.onClear,
    required this.showClearButton,
    this.hintText = 'Who you\'re looking for?',
  });

  final TextEditingController  searchController;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClearButton;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: showClearButton
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: context.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.primaryBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.primaryBlue,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}