import 'package:flutter/material.dart';

class BottomNavBarModel extends ChangeNotifier {
  bool show = true;

  void showBottomNavBar() {
    show = true;
    notifyListeners();
  }

  void hideBottomNavBar() {
    show = false;
    notifyListeners();
  }
}
