import 'package:flutter/material.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';

class StatsTab extends StatelessWidget {
  final Pokemon pokemon;
  const StatsTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final total = pokemon.stats.fold<int>(0, (s, e) => s + e.baseStat);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final s in pokemon.stats) _StatBar(stat: s),
        const SizedBox(height: 12),
        Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$total', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  final PokemonStat stat;
  const _StatBar({required this.stat});

  String get label {
    switch (stat.statName) {
      case 'hp': return 'HP';
      case 'attack': return 'Attack';
      case 'defense': return 'Defence';
      case 'special-attack': return 'Special Attack';
      case 'special-defense': return 'Special Defense';
      case 'speed': return 'Speed';
      default: return HelperMethods.cap(stat.statName.replaceAll('-', ' '));
    }
  }

  @override
  Widget build(BuildContext context) {
    const max = 255.0;
    final v = (stat.baseStat / max).clamp(0.0, 1.0);
    final color = HelperMethods.statColor(stat.statName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium,),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: v,
                    minHeight: 12,
                    color: color,
                    backgroundColor: color.withValues(alpha: .2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 36, child: Text('${stat.baseStat}', textAlign: TextAlign.end)),
            ],
          ),
        ],
      ),
    );
  }
}
