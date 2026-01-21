import 'package:flutter/material.dart';

class StringUtil {
  static String getInitials(String str) {
    if (str.isEmpty) {
      return '';
    }

    final regex = RegExp(r"[. ',_-]");
    final pieces = str
        .split(regex)
        .map((piece) {
          return piece.trim();
        })
        .where((piece) {
          return piece.isNotEmpty;
        })
        .toList();

    if (pieces.length == 1) {
      final piece = pieces.first.trim();

      if (piece.length == 1) {
        return piece.toUpperCase();
      }

      return piece.substring(0, 2).toUpperCase();
    } else if (pieces.length > 1) {
      return (pieces[0].substring(0, 1) + pieces[pieces.length - 1].substring(0, 1)).toUpperCase();
    }

    return '';
  }

  static List<Color> getColorFromText(String str) {
    var code = 0;
    for (var i = 0; i < str.length; i++) {
      code = str.codeUnitAt(i) + code;
    }

    var index = code % Colors.primaries.length;
    index = index == 0 ? index : index - 1;
    final backgroundColor = Colors.primaries[index];
    final textColor = ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return [backgroundColor, textColor];
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this; // Return the original string if it's empty
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String unCapitalize() {
    if (isEmpty) {
      return this; // Return the original string if it's empty
    }
    return "${this[0].toLowerCase()}${substring(1)}";
  }

  String capitalizeFirstOfEachWord() {
    if (isEmpty) {
      return this;
    }
    return split(' ')
        .map((word) {
          if (word.isEmpty) {
            return '';
          }
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  bool isPasswordComplex() {
    // Define the regular expression pattern
    final pattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d]).{8,}$');

    // Test the password against the regular expression
    return pattern.hasMatch(this);
  }
}
