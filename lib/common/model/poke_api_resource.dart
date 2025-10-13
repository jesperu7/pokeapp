class PokeAPIResource {
  final String name;
  final String url;

  const PokeAPIResource({required this.name, required this.url});

  factory PokeAPIResource.fromJson(final Map<String, dynamic> json) {
    return PokeAPIResource(name: json['name'] as String, url: json['url'] as String);
  }

  static int idFromUrl(String url) {
    final segments = Uri.parse(url).pathSegments;
    return int.parse(segments[segments.length - 2]);
  }
}