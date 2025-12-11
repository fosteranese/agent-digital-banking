import 'package:flutter/material.dart';

class ListUtil {
  static List<Widget> separatedLis<T>({
    required List<T> list,
    required Widget Function(T) item,
    Widget? separator,
  }) =>
      list
          .map((e) {
            final itemList = <Widget>[];
            itemList.add(item(e));

            if (list.last != e) {
              itemList.add(separator ??
                  const Divider(
                    color: Color(0xffF1F1F1),
                    indent: 60,
                  ));
            }
            return itemList;
          })
          .expand((element) => element)
          .toList();
}