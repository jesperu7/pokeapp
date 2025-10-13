import 'package:pokeapp/common/model/poke_api_resource.dart';

class PokemonListItem {
  final int id;
  final String name;

  PokemonListItem({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PokemonListItem &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory PokemonListItem.fromAPIResource(PokeAPIResource resource) {
    return PokemonListItem(id: PokeAPIResource.idFromUrl(resource.url), name: resource.name);
  }

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(id: json['id'], name: json['name']);
  }

  static List<PokemonListItem> fromJsonList(List<dynamic> json) {
    return json.map((item) => PokemonListItem.fromJson(item)).toList();
  }

  static List<PokemonListItem> fromApiResourceList(List<Map<String, dynamic>> json) {
    List<PokemonListItem> list = [];
    for (var e in json) {
      final apiResource = PokeAPIResource.fromJson(e);
      list.add(PokemonListItem.fromAPIResource(apiResource));
    }
    return list;
  }

  static List<PokemonListItem> fromApiList(List<dynamic> jsonList) {
    return jsonList.map((item) {
      final map = item as Map<String, dynamic>;
      final name = map['name'] as String;
      final url = map['url'] as String;
      final id = PokeAPIResource.idFromUrl(url);
      return PokemonListItem(id: id, name: name);
    }).toList(growable: false);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

extension PokemonDetailsBundleListExtension on List<PokemonListItem> {
  List<Map<String, dynamic>> toJson() {
    return map((bundle) => bundle.toJson()).toList();
  }
}