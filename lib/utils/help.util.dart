import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/pages/help.page.dart';

class HelpUtil {
  static void show({required void Function() onCancelled}) {
    _showSupplier(onCancelled);
  }

  static void _showSupplier(void Function() onCancelled) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: MyApp.navigatorKey.currentContext!,
      backgroundColor: Colors.black,
      useSafeArea: true,
      builder: (context) {
        return HelpPage();
      },
    );
  }
}
