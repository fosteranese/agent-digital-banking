import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agent_digital_banking/utils/app.util.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({super.key});

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  final _controller = CarouselController(initialItem: 0);

  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      height: isActive ? 5 : 5,
      width: isActive ? 15 : 5,
      decoration: BoxDecoration(color: isActive ? Colors.white : Colors.white60, borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }

  void _nextPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  initState() {
    super.initState();
    _controller.addListener(() {
      final position = _controller.position;
      final width = MediaQuery.sizeOf(context).width - 32;
      if (position.hasPixels) {
        final index = (position.pixels / width).round();
        _nextPage(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 109,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselView(
              controller: _controller,
              itemExtent: double.maxFinite,
              itemSnapping: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onTap: (index) {
                final advert = AppUtil.data.adverts?[index];
                if (advert?.walkUrl?.isEmpty ?? true) {
                  return;
                }

                final url = Uri.parse(advert!.walkUrl!);
                launchUrl(url);
              },
              children:
                  AppUtil.data.adverts?.map((advert) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(imageUrl: '${AppUtil.data.imageBaseUrl}${AppUtil.data.imageDirectory}/${advert.picture}', fit: BoxFit.cover),
                    );
                  }).toList() ??
                  [],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: _buildPageIndicator(AppUtil.data.adverts?.length ?? 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
