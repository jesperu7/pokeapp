sealed class LibraryFilter {}

class TypeFilter extends LibraryFilter {
  final String value;

  TypeFilter(this.value);
}

class GenerationFilter extends LibraryFilter {
  final String value;

  GenerationFilter(this.value);
}

class NoFilter extends LibraryFilter {}