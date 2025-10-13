import 'package:pokeapp/common/model/poke_api_resource.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';

class PokemonDetailsBundle {
  final Pokemon pokemon;
  final PokemonSpecies species;
  final EvolutionNode? evolution;

  const PokemonDetailsBundle({required this.pokemon, required this.species, this.evolution});
}

class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonTypeSlot> types;
  final List<PokemonAbilitySlot> abilities;
  final List<PokemonStat> stats;
  final String artworkUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.artworkUrl,
  });

  PokemonListItem get toListItem => PokemonListItem(id: id, name: name);

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    String? art =
        (((json['sprites'] as Map?)?['other'] as Map?)?['official-artwork']
                as Map?)?['front_default']
            as String?;
    art ??=
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types:
          (json['types'] as List)
              .map((e) => PokemonTypeSlot.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.slot.compareTo(b.slot)),
      abilities: (json['abilities'] as List)
          .map((e) => PokemonAbilitySlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List)
          .map((e) => PokemonStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      artworkUrl: art,
    );
  }
}

class PokemonTypeSlot {
  final int slot;
  final String typeName;

  const PokemonTypeSlot({required this.slot, required this.typeName});

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      PokemonTypeSlot(slot: json['slot'] as int, typeName: (json['type'] as Map)['name'] as String);
}

class PokemonAbilitySlot {
  final String abilityName;
  final bool isHidden;

  const PokemonAbilitySlot({required this.abilityName, required this.isHidden});

  factory PokemonAbilitySlot.fromJson(Map<String, dynamic> json) => PokemonAbilitySlot(
    abilityName: (json['ability'] as Map)['name'] as String,
    isHidden: json['is_hidden'] as bool,
  );
}

class PokemonStat {
  final String statName;
  final int baseStat;

  const PokemonStat({required this.statName, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) => PokemonStat(
    statName: (json['stat'] as Map)['name'] as String,
    baseStat: json['base_stat'] as int,
  );
}

class PokemonSpecies {
  final String genusEn;
  final String flavorTextEn;
  final int captureRate;
  final int? baseHappiness;
  final String growthRate;
  final List<String> eggGroups;
  final int genderRate;
  final int hatchCounter;
  final String? evolutionChainUrl;
  final String generation;
  final String color;

  const PokemonSpecies({
    required this.genusEn,
    required this.flavorTextEn,
    required this.captureRate,
    required this.baseHappiness,
    required this.growthRate,
    required this.eggGroups,
    required this.genderRate,
    required this.hatchCounter,
    required this.evolutionChainUrl,
    required this.generation,
    required this.color,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    String pickEnGenus(List list) {
      for (final g in list) {
        final m = g as Map<String, dynamic>;
        if ((m['language'] as Map)['name'] == 'en') return m['genus'] as String;
      }
      return '';
    }

    String pickEnFlavor(List list) {
      // Take the last EN flavor text (often newest)
      for (final e in list.reversed) {
        final m = e as Map<String, dynamic>;
        if ((m['language'] as Map)['name'] == 'en') {
          final raw = m['flavor_text'] as String? ?? '';
          return raw.replaceAll('\n', ' ').replaceAll('\f', ' ').trim();
        }
      }
      return '';
    }

    return PokemonSpecies(
      genusEn: pickEnGenus(json['genera'] as List),
      flavorTextEn: pickEnFlavor(json['flavor_text_entries'] as List),
      captureRate: json['capture_rate'] as int,
      baseHappiness: json['base_happiness'] as int?,
      growthRate: (json['growth_rate'] as Map)['name'] as String,
      eggGroups: (json['egg_groups'] as List).map((e) => (e as Map)['name'] as String).toList(),
      genderRate: json['gender_rate'] as int,
      hatchCounter: json['hatch_counter'] as int,
      evolutionChainUrl: (json['evolution_chain'] as Map?)?['url'] as String?,
      generation: (json['generation'] as Map)['name'] as String,
      color: (json['color'] as Map)['name'] as String,
    );
  }
}

class EvolutionNode {
  final String speciesName;
  final int speciesId;
  final List<EvolutionDetail> details;
  final List<EvolutionNode> evolvesTo;

  EvolutionNode({
    required this.speciesName,
    required this.speciesId,
    required this.details,
    required this.evolvesTo,
  });

  factory EvolutionNode.fromChainJson(Map<String, dynamic> json) {
    EvolutionNode build(Map<String, dynamic> node, {List<EvolutionDetail>? via}) {
      final species = node['species'] as Map<String, dynamic>;
      final evoDetails = (node['evolution_details'] as List? ?? [])
          .map((e) => EvolutionDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      final children = (node['evolves_to'] as List)
          .map((e) => build(e as Map<String, dynamic>))
          .toList();

      return EvolutionNode(
        speciesName: species['name'] as String,
        speciesId: PokeAPIResource.idFromUrl(species['url']),
        details: via ?? evoDetails,
        evolvesTo: children,
      );
    }

    return build(json);
  }
}

class EvolutionDetail {
  final String trigger;
  final int? minLevel;
  final String? item;
  final String? heldItem;
  final String? knownMove;
  final String? location;
  final bool needsOverworldRain;
  final bool turnUpsideDown;

  EvolutionDetail({
    required this.trigger,
    this.minLevel,
    this.item,
    this.heldItem,
    this.knownMove,
    this.location,
    this.needsOverworldRain = false,
    this.turnUpsideDown = false,
  });

  factory EvolutionDetail.fromJson(Map<String, dynamic> json) => EvolutionDetail(
    trigger: (json['trigger'] as Map?)?['name'] as String? ?? '',
    minLevel: json['min_level'] as int?,
    item: (json['item'] as Map?)?['name'] as String?,
    heldItem: (json['held_item'] as Map?)?['name'] as String?,
    knownMove: (json['known_move'] as Map?)?['name'] as String?,
    location: (json['location'] as Map?)?['name'] as String?,
    needsOverworldRain: (json['needs_overworld_rain'] as bool?) ?? false,
    turnUpsideDown: (json['turn_upside_down'] as bool?) ?? false,
  );
}
