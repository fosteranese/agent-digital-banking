import 'package:flutter/material.dart';

class PopOver extends StatelessWidget {
  const PopOver({super.key, required this.child, this.onClose, this.transparent = false});

  final Widget child;
  final bool transparent;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        // margin: const EdgeInsets.all(16.0),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onClose != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: IconButton(
                      // padding: const EdgeInsets.all(0),
                      // alignment: Alignment.topCenter,
                      onPressed: onClose,
                      icon: const Icon(Icons.clear, size: 25),
                    ),
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
