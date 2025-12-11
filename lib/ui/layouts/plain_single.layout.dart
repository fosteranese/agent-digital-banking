import 'package:flutter/material.dart';

import '../components/form/button.dart';

class PlainSingleLayout extends StatelessWidget {
  const PlainSingleLayout({
    super.key,
    this.backIcon,
    this.onPressHelped,
    this.title,
    required this.child,
    this.useCloseIcon = false,
    this.onBackPressed,
    this.showHelp = false,
  });

  final Widget? backIcon;
  final void Function()? onPressHelped;
  final String? title;
  final Widget child;
  final bool useCloseIcon;
  final void Function()? onBackPressed;
  final bool showHelp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        titleSpacing: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              color: Colors.black,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).primaryColorLight.withAlpha(64),
              ),
              onPressed:
                  onBackPressed ??
                  () {
                    Navigator.pop(context);
                  },
              icon:
                  backIcon ??
                  (useCloseIcon
                      ? const Icon(Icons.clear)
                      : const Icon(Icons.arrow_back)),
            ),
            if (showHelp) const Spacer(),
            if (showHelp)
              SizedBox(
                width: 90,
                child: FormButton(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColorLight.withAlpha(64),
                  onPressed: onPressHelped ?? () => {},
                  text: 'Help',
                ),
              ),
          ],
        ),
      ),
      body: child,
    );
  }
}
