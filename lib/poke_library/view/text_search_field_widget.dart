import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_view_model.dart';

class TextSearchFieldWidget extends StatefulWidget {
  const TextSearchFieldWidget({super.key});

  @override
  State<TextSearchFieldWidget> createState() => _TextSearchFieldWidgetState();
}

class _TextSearchFieldWidgetState extends State<TextSearchFieldWidget> {
  final _vm = GetIt.I<PokeLibraryViewModel>();

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: _vm.applySearchWord,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.clear),
            onPressed: _clear,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _clear() {
    _vm.resetSearch();
    _controller.clear();
    _focusNode.unfocus();
  }
}
