import 'package:intl/intl.dart';

class FormatterUtil {
  static final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  static String currency(dynamic amount) {
    return currencyFormatter.format(amount);
  }

  static String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result = '';
    if (hourLeft != '00') {
      result = '$hourLeft:';
    }

    // if (minuteLeft != '00') {
    //   result += '$minuteLeft:';
    // }

    result = '$result$minuteLeft:$secondsLeft';

    return result;
  }

  static String fullDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd yyyy hh:mm a');
    return formatter.format(date);
  }

  static String shortDateOnly(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd yyyy');
    return formatter.format(date);
  }

  static String timeOnly(DateTime date) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }

  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  static String getInitials(String name) {
    if (name.isEmpty) {
      return '';
    }

    name = name.trim().toUpperCase();
    if (name.length == 1) {
      return name;
    }

    var pieces = name.split(' ');
    if (pieces.length == 1) {
      return name.substring(0, 2);
    }

    return '${pieces[0].substring(0, 1)}${pieces[1].substring(0, 1)}';
  }
}
