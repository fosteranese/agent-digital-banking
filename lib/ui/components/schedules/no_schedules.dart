import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class NoSchedulesView extends StatelessWidget {
  const NoSchedulesView({super.key, required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/img/empty.svg', width: 64),
                const SizedBox(height: 10),
                Text(
                  'Nothing found',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff4F4F4F)),
                ),
                Text(
                  'You currently have no standing order or schedule',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff919195)),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
