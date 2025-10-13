import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokeapp/common/helper_methods.dart';

class PokemonImageWidget extends StatelessWidget {
  final int id;
  final double? height;
  final double? width;
  final BoxFit fit;

  const PokemonImageWidget({
    super.key,
    required this.id,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: HelperMethods.artUrl(id),
      height: height,
      width: width,
    );
  }
}
