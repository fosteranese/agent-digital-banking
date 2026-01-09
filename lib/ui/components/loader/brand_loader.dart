import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class BrandLoader extends StatefulWidget {
  const BrandLoader({super.key});

  @override
  State<BrandLoader> createState() => _BrandLoaderState();
}

class _BrandLoaderState extends State<BrandLoader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: CupertinoActivityIndicator(radius: 20, color: ThemeUtil.primaryColor),
        ),
      ],
    );
  }
}
