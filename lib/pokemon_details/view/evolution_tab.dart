import 'package:flutter/material.dart';
import 'package:pokeapp/common/view/pokemon_image_widget.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';

class EvolutionTab extends StatelessWidget {
  final EvolutionNode? root;

  const EvolutionTab({super.key, required this.root});

  @override
  Widget build(BuildContext context) {
    if (root == null) {
      return const Center(child: Text('No evolution data'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [_EvolutionBranch(node: root!)],
    );
  }
}

class _EvolutionBranch extends StatelessWidget {
  final EvolutionNode node;

  const _EvolutionBranch({required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EvolutionTile(node: node),
        for (final child in node.evolvesTo) ...[
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_downward, size: 18),
              ),
              Expanded(child: Divider()),
            ],
          ),
          if (child.details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                _evoCondition(child.details.first),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          _EvolutionBranch(node: child),
        ],
      ],
    );
  }

  static String _evoCondition(EvolutionDetail d) {
    if (d.item != null) return 'Use ${HelperMethods.cap(d.item!.replaceAll('-', ' '))}';
    if (d.trigger == 'trade') return 'Trade';
    if (d.minLevel != null) return 'Level ${d.minLevel}';
    if (d.knownMove != null) return 'Knows ${HelperMethods.cap(d.knownMove!.replaceAll('-', ' '))}';
    if (d.location != null) return 'At ${HelperMethods.cap(d.location!.replaceAll('-', ' '))}';
    if (d.needsOverworldRain) return 'While raining';
    if (d.turnUpsideDown) return 'Hold console upside down';
    return HelperMethods.cap(d.trigger.replaceAll('-', ' '));
  }
}

class _EvolutionTile extends StatelessWidget {
  final EvolutionNode node;

  const _EvolutionTile({required this.node});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: PokemonImageWidget(id: node.speciesId, height: 56, width: 56),
        title: Text(HelperMethods.cap(node.speciesName)),
        subtitle: Text('#${node.speciesId.toString().padLeft(4, "0")}'),
      ),
    );
  }
}
