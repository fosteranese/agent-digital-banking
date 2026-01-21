import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class IntroSlide extends StatelessWidget {
  const IntroSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (!imageUrl.startsWith("https://")) {
      var file = File(imageUrl);
      if (!file.existsSync()) {
        return SizedBox();
      }

      var assetImage = FileImage(file);
      return ImageBackground(title: title, subtitle: subtitle, imageProvider: assetImage);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) =>
          ImageBackground(title: title, subtitle: subtitle, imageProvider: imageProvider),
      width: double.maxFinite,
      placeholder: (context, url) {
        return Container(color: Colors.grey);
      },
      fit: BoxFit.cover,
    );
  }
}

class ImageBackground extends StatelessWidget {
  const ImageBackground({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageProvider,
  });

  final String title;
  final String subtitle;
  final ImageProvider<Object> imageProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(60)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        // Container(color: Colors.black.withAlpha(100)),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 100, left: 20.0, right: 20.0),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: PrimaryTextStyle(
                    fontSize: 39,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: PrimaryTextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
