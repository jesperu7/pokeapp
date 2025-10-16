import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';
import 'package:pokeapp/pokemon_details/model/data/pokemon_details_remote_source.dart';


class MockPokemonDetailsRemoteSource implements IPokemonDetailsRemoteSource {
  final Map<String, Result<PokemonDetailsBundle>> _responses = {};

  @override
  Future<Result<PokemonDetailsBundle>> fetchPokemonDetails(String nameOrId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _responses[nameOrId] ?? Result.error(Exception('Not found'));
  }

  void setResponse(String nameOrId, Result<PokemonDetailsBundle> result) {
    _responses[nameOrId] = result;
  }

  void clearResponses() {
    _responses.clear();
  }
}

PokemonDetailsBundle createMockPokemonDetailsBundle() {
  return PokemonDetailsBundle(
    pokemon: Pokemon(
      id: 25,
      name: 'pikachu',
      height: 4,
      weight: 60,
      types: [
        PokemonTypeSlot(slot: 1, typeName: 'electric'),
      ],
      abilities: [
        PokemonAbilitySlot(abilityName: 'static', isHidden: false),
      ],
      stats: [
        PokemonStat(statName: 'hp', baseStat: 35),
        PokemonStat(statName: 'attack', baseStat: 55),
      ],
      artworkUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
    ),
    species: PokemonSpecies(
      genusEn: 'Mouse Pokémon',
      flavorTextEn: 'Pikachu stores electricity in its cheeks.',
      captureRate: 190,
      baseHappiness: 70,
      growthRate: 'medium-fast',
      eggGroups: ['field', 'fairy'],
      genderRate: 4, // 50% male, 50% female
      hatchCounter: 10,
      evolutionChainUrl: 'https://pokeapi.co/api/v2/evolution-chain/10/',
      generation: 'generation-i',
      color: 'yellow',
    ),
    evolution: EvolutionNode(
      speciesName: 'pikachu',
      speciesId: 25,
      details: [
        EvolutionDetail(
          trigger: 'level-up',
          minLevel: 16,
        ),
      ],
      evolvesTo: [
        EvolutionNode(
          speciesName: 'raichu',
          speciesId: 26,
          details: [
            EvolutionDetail(
              trigger: 'use-item',
              item: 'thunder-stone',
            ),
          ],
          evolvesTo: [],
        ),
      ],
    ),
  );
}