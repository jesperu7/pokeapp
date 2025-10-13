import 'package:flutter/material.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/common/view/pokemon_image_widget.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/pokemon_details/view/favorite_icon_button.dart';

class PokemonDisplayCardWidget extends StatelessWidget {
  final PokemonListItem item;
  final VoidCallback onDetails;
  final VoidCallback? onAnother;

  const PokemonDisplayCardWidget({
    super.key,
    required this.item,
    required this.onDetails,
    this.onAnother,
  });

  @override
  Widget build(BuildContext context) {
    final title = '#${item.id.toString().padLeft(4, "0")} ${HelperMethods.cap(item.name)}';

    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: onDetails,
                    child: PokemonImageWidget(id: item.id, height: 300, fit: BoxFit.contain),
                  ),
                ),
                Align(
                  alignment: AlignmentGeometry.topRight,
                  child: FavoriteIconButton(pokemon: item),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onDetails,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Learn more'),
                    ),
                  ),
                  if (onAnother != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: OutlinedButton.icon(
                          onPressed: onAnother,
                          icon: const Icon(Icons.casino),
                          label: const Text('Another!'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
