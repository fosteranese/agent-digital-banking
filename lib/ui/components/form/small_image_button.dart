import 'package:flutter/material.dart';

class SmallImageButton extends StatelessWidget {
  const SmallImageButton({
    super.key,
    required this.text,
    required this.image,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  final String text;
  final String image;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              letterSpacing: -0.5,
              color: Colors.black,
            ),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/$image",
            height: 24,
          ),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}