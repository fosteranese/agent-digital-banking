import 'package:flutter/material.dart';

class BackgroundLayout extends StatelessWidget {
  const BackgroundLayout({
    super.key,
    this.backIcon,
    this.onPressHelped,
    this.title,
    required this.children,
    this.useCloseIcon = false,
    this.onBackPressed,
    this.backgroundImageUrl,
  });

  final Widget? backIcon;
  final void Function()? onPressHelped;
  final String? title;
  final List<Widget> children;
  final bool useCloseIcon;
  final void Function()? onBackPressed;
  final String? backgroundImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(backgroundImageUrl ?? 'assets/img/intro-4.png', fit: BoxFit.cover),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leadingWidth: 0,
                  titleSpacing: 10,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        color: Colors.black,
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight.withAlpha(64),
                        ),
                        onPressed:
                            onBackPressed ??
                            () {
                              Navigator.pop(context);
                            },
                        icon:
                            backIcon ??
                            (useCloseIcon ? const Icon(Icons.clear) : const Icon(Icons.arrow_back)),
                      ),
                      const Spacer(),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight.withAlpha(64),
                        ),
                        onPressed: onPressHelped ?? () => {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Make a report',
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [SizedBox(height: 30), ...children],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
