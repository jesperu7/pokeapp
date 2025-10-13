import 'package:pokeapp/common/model/poke_api_resource.dart';

class FilterListResponse {
  final List<PokeAPIResource> results;

  const FilterListResponse({required this.results});

  factory FilterListResponse.fromJson(Map<String, dynamic> json) {
    return FilterListResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => PokeAPIResource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

