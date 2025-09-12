import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctorfriend/screens/image_screen.dart';

class CarroselImage extends StatelessWidget {
  final List<String> images;
  const CarroselImage({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    goToImage(image) {
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => ImageScreen(image, image),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 4.5 / 2.5,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              enlargeFactor: 0.20,
              scrollDirection: Axis.horizontal,
            ),
            items: images
                .map(
                  (image) => InkWell(
                    onTap: () => goToImage(image),
                    child: Image.network(image),
                  ),
                )
                .toList()),
      ],
    );
  }
}
