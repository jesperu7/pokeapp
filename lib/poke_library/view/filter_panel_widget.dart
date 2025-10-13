import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/poke_library/model/library_filter.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_view_model.dart';

class FilterPanelWidget extends StatefulWidget {
  const FilterPanelWidget({super.key});

  @override
  State<FilterPanelWidget> createState() => _FilterPanelWidgetState();
}

class _FilterPanelWidgetState extends State<FilterPanelWidget> {
  final _vm = GetIt.I<PokeLibraryViewModel>();
  late LibraryFilter _selected;

  @override
  void initState() {
    _selected = _vm.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder(
          valueListenable: _vm.filterListenable,
          builder: (context, value, child) {
            if (value == null) return const Center(child: CircularProgressIndicator());

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Generations', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final g in value.generations)
                      ChoiceChip(
                        label: Text(HelperMethods.genLabel(g)),
                        selected: _isSelected(g),
                        onSelected: (_) => setState(() => _selected = GenerationFilter(g)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Types', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in value.types)
                      ChoiceChip(
                        label: Text(t),
                        selected: _isSelected(t),
                        onSelected: (_) => setState(() => _selected = TypeFilter(t)),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _vm.applyFilter(NoFilter());
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          _vm.applyFilter(_selected);
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isSelected(String f) {
    switch (_selected) {
      case TypeFilter(value: var v):
      case GenerationFilter(value: var v):
        return v == f;
      case NoFilter():
        return false;
    }
  }
}
