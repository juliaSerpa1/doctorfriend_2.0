import 'package:doctorfriend/components/app_image.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  const ImageScreen(this.imageUrl, this.heroTag, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: heroTag,
        child: AppImage(
          imageUrl: imageUrl,
          withHero: false,
        ),
      ),
    );
  }
}
