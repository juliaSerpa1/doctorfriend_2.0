import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:doctorfriend/screens/image_screen.dart';

const _defaultImage = 'assets/images/avatar.png';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final bool isCircular;
  final bool withHero;
  const AppImage({
    super.key,
    required this.imageUrl,
    this.isCircular = false,
    this.withHero = true,
  });

  _goToImage(BuildContext context, String heroTag) {
    final String url = imageUrl!;
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => ImageScreen(url, heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    final path = imageUrl ?? _defaultImage;
    final index = Random().nextInt(1000);
    String heroTag = "$path-$index";
    final uri = Uri.parse(path);

    if (uri.path.contains(_defaultImage)) {
      provider = const AssetImage(_defaultImage);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(path));
    }
    if (isCircular) {
      return CircleAvatar(
        backgroundImage: provider,
      );
    }
    if (!withHero) {
      return Center(
        child: Image(
          image: provider,
        ),
      );
    }

    return InkWell(
      onTap: () => _goToImage(context, heroTag),
      child: Hero(
        tag: heroTag,
        child: Center(
          child: Image(
            image: provider,
            errorBuilder: (e, _, __) {
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
