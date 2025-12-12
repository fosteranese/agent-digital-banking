import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:my_sage_agent/data/models/account/source.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key, this.index = 0, required this.data});

  final int index;
  final Source data;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  final _visible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      enableFeedback: true,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.tile ?? '', style: PrimaryTextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(widget.data.accountNumber ?? '', style: PrimaryTextStyle(color: Color(0xff919195), fontSize: 13)),
                  const SizedBox(height: 15),
                  ValueListenableBuilder(
                    valueListenable: _visible,
                    builder: (context, value, child) {
                      if (value) {
                        return Text(
                          widget.data.balance ?? '',
                          style: PrimaryTextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
                        );
                      }
                      return Text(
                        'GHS***********',
                        style: PrimaryTextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                _visible.value = !_visible.value;
              },
              child: ValueListenableBuilder(
                valueListenable: _visible,
                builder: (context, value, child) {
                  return Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset(_visible.value ? 'assets/img/hide.svg' : 'assets/img/show.svg'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
