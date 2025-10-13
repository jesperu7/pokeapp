import 'package:flutter/material.dart';

class HelperMethods {
  static String cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String artUrl(int id) => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  static Color typeColor(String t) {
    switch (t) {
      case 'grass': return const Color(0xFF78C850);
      case 'fire': return const Color(0xFFF08030);
      case 'water': return const Color(0xFF6890F0);
      case 'electric': return const Color(0xFFF8D030);
      case 'ice': return const Color(0xFF98D8D8);
      case 'fighting': return const Color(0xFFC03028);
      case 'poison': return const Color(0xFFA040A0);
      case 'ground': return const Color(0xFFE0C068);
      case 'flying': return const Color(0xFFA890F0);
      case 'psychic': return const Color(0xFFF85888);
      case 'bug': return const Color(0xFFA8B820);
      case 'rock': return const Color(0xFFB8A038);
      case 'ghost': return const Color(0xFF705898);
      case 'dragon': return const Color(0xFF7038F8);
      case 'dark': return const Color(0xFF705848);
      case 'steel': return const Color(0xFFB8B8D0);
      case 'fairy': return const Color(0xFFEE99AC);
      default: return const Color(0xFF8A8A8A);
    }
  }

  static Color statColor(String stat) {
    switch (stat) {
      case 'hp': return const Color(0xFFDF4A63);
      case 'attack': return const Color(0xFFF5AC78);
      case 'defense': return const Color(0xFFFAE078);
      case 'special-attack': return const Color(0xFF9DB7F5);
      case 'special-defense': return const Color(0xFFA7DB8D);
      case 'speed': return const Color(0xFFF5A6B3);
      default: return Colors.blueGrey;
    }
  }

  static String genLabel(String apiName) {
    const map = {
      'generation-i': 'Gen I',
      'generation-ii': 'Gen II',
      'generation-iii': 'Gen III',
      'generation-iv': 'Gen IV',
      'generation-v': 'Gen V',
      'generation-vi': 'Gen VI',
      'generation-vii': 'Gen VII',
      'generation-viii': 'Gen VIII',
      'generation-ix': 'Gen IX',
    };
    return map[apiName] ?? apiName;
  }

}

