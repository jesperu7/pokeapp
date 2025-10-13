import 'package:flutter/material.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';

class AboutTab extends StatelessWidget {
  final PokemonDetailsBundle bundle;

  const AboutTab({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final p = bundle.pokemon;
    final s = bundle.species;

    // value from api is decimeter/hectogram
    final heightM = (p.height / 10).toStringAsFixed(1);
    final weightKg = (p.weight / 10).toStringAsFixed(1);

    final hasGender = s.genderRate >= 0;
    final femalePct = hasGender ? (s.genderRate * 12.5) : 0.0;
    final malePct = hasGender ? (100 - femalePct) : 0.0;

    final hatchSteps = (s.hatchCounter + 1) * 255;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in p.types)
              Chip(
                label: Text(HelperMethods.cap(t.typeName)),
                backgroundColor: HelperMethods.typeColor(t.typeName).withValues(alpha: .2),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          s.genusEn.isNotEmpty ? s.genusEn : 'Pokémon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(s.flavorTextEn, style: Theme.of(context).textTheme.bodyMedium),

        const SizedBox(height: 20),
        _SectionTitle('Base Info'),
        _InfoRow('Height', '$heightM m'),
        _InfoRow('Weight', '$weightKg kg'),
        _InfoRow('Capture Rate', s.captureRate.toString()),
        if (s.baseHappiness != null) _InfoRow('Base Happiness', s.baseHappiness.toString()),
        _InfoRow('Growth Rate', HelperMethods.cap(s.growthRate.replaceAll('-', ' '))),
        _InfoRow('Egg Groups', s.eggGroups.map(HelperMethods.cap).join(', ')),
        _InfoRow('Generation', s.generation.toUpperCase()),
        _InfoRow('Color', HelperMethods.cap(s.color)),
        if (hasGender) _InfoRow('Gender Ratio', '♂ ${malePct.round()}%  ♀ ${femalePct.round()}%'),
        _InfoRow('Hatch Steps', '$hatchSteps'),

        const SizedBox(height: 20),
        _SectionTitle('Abilities'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in p.abilities)
              Chip(
                label: Text(HelperMethods.cap(a.abilityName)),
                avatar: a.isHidden ? const Icon(Icons.visibility_off, size: 16) : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
