import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  static const List<Map<String, dynamic>> _cards = [
    {
      'color': ThemeUtil.primaryColor1,
      'iconColor': Color(0xff00569C),
      'icon': 'assets/img/cash-collected.svg',
      'title': '',
      'caption': 'Cash Collected',
    },
    {
      'color': Color(0xff5A7CBC),
      'iconColor': Color(0xff224B98),
      'icon': 'assets/img/money.svg',
      'title': '',
      'caption': 'Cash Deposited',
    },
    {
      'color': Color(0xff57B16B),
      'iconColor': Color(0xff308F46),
      'icon': 'assets/img/cash-collected.svg',
      'title': '',
      'caption': 'Cash at Hand',
    },
    {
      'color': Color(0xffE53793),
      'iconColor': Color(0xff820849),
      'icon': 'assets/img/wallet.svg',
      'title': '',
      'caption': 'MoMo Collected',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 170,
        padding: EdgeInsets.symmetric(vertical: 20),
        color: Color(0xffF3F4F9),
        child: PageView(
          padEnds: false,
          controller: PageController(viewportFraction: 0.8),
          children: _cards.map((item) {
            final title = 'GHS 0.00';
            return Container(
              margin: EdgeInsets.only(
                left: (item['caption'] == _cards.first['caption'] ? 20 : 10),
                right: (item['caption'] == _cards.last['caption'] ? 20 : 0),
              ),

              padding: EdgeInsets.all(20),
              // width: double.maxFinite,
              height: double.maxFinite,

              decoration: BoxDecoration(
                color: item['color'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item['iconColor'],
                    radius: 25,
                    child: SvgPicture.asset(
                      item['icon'],
                      width: 30,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.mulish(
                            fontWeight: .w600,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item['caption'],
                          style: GoogleFonts.mulish(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
