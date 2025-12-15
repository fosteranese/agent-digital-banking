import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/ui/pages/register/step_1.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardActions extends StatelessWidget {
  const DashboardActions({super.key});

  List<Map<String, dynamic>> _actions(BuildContext context) => [
    {
      'onPressed': () {
        MessageUtil.displayLoading(context);
        Future.delayed(const Duration(seconds: 3), () {
          context.pop();
        });
      },
      'color': Color(0x295801B6),
      'icon': 'assets/img/client-deposit.svg',
      'title': 'Deposit for Client',
      'caption': 'Deposit for client',
    },
    {
      'onPressed': () {
        context.push(RegisterStep1Page.routeName);
      },
      'color': Color(0x29034D89),
      'icon': 'assets/img/group.svg',
      'title': 'Onboard Client',
      'caption': 'Register new client',
    },
    {
      'onPressed': () {
        MessageUtil.displayLoading(context);
        Future.delayed(const Duration(seconds: 3), () {
          context.pop();
        });
      },
      'color': Color(0x292719CA),
      'icon': 'assets/img/invest.svg',
      'title': 'Investment',
      'caption': 'Invest for client',
    },
    {
      'onPressed': () {
        MessageUtil.displayLoading(context);
        Future.delayed(const Duration(seconds: 3), () {
          context.pop();
        });
      },
      'color': Color(0x2919CA74),
      'icon': 'assets/img/loan.svg',
      'title': 'Loan Request',
      'caption': 'Loan request for client',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final actions = _actions(context);
    return SliverPadding(
      padding: const .only(top: 20, left: 20, right: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Text(
              'What do you want to do?',
              style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 320,
              child: GridView(
                padding: .zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: actions.map((item) {
                  return InkWell(
                    onTap: item['onPressed'],
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 19,
                            child: SvgPicture.asset(item['icon']),
                          ),
                          Spacer(),
                          Text(
                            item['title'],
                            maxLines: 1,
                            style: PrimaryTextStyle(
                              fontSize: 14,
                              fontWeight: .w700,
                              color: ThemeUtil.black,
                            ),
                          ),
                          Text(
                            item['caption'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PrimaryTextStyle(
                              fontSize: 13,
                              fontWeight: .w600,
                              color: ThemeUtil.flat,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
