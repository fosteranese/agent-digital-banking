import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import 'package:my_sage_agent/data/models/account/source.dart';

class AccountsCarousel extends StatefulWidget {
  const AccountsCarousel({super.key, required this.accounts, required ValueNotifier<bool> displayBalance, required ValueNotifier<bool> viewAccounts, required ScrollController controller}) : _displayBalance = displayBalance, _viewAccounts = viewAccounts;

  final List<Source> accounts;
  final ValueNotifier<bool> _displayBalance;
  final ValueNotifier<bool> _viewAccounts;

  @override
  State<AccountsCarousel> createState() => _AccountsCarouselState();
}

class _AccountsCarouselState extends State<AccountsCarousel> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      height: isActive ? 7.0 : 7.0,
      width: isActive ? 7.0 : 7.0,
      decoration: BoxDecoration(color: isActive ? Theme.of(context).primaryColorDark : Color(0x80B7861A), borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }

  void _nextPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._viewAccounts,
      builder: (context, display, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: _nextPage,
                pageSnapping: true,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                children: widget.accounts.map((e) {
                  return ValueListenableBuilder(
                    valueListenable: widget._displayBalance,
                    builder: (context, value, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.tile ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: PrimaryTextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      e.accountNumber ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: PrimaryTextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      (value || display) ? (e.balance ?? '') : 'GHS***********',
                                      style: PrimaryTextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  widget._displayBalance.value = !widget._displayBalance.value;
                                },
                                child: Padding(padding: const EdgeInsets.all(5), child: SvgPicture.asset(value ? 'assets/img/hide.svg' : 'assets/img/show.svg')),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._buildPageIndicator(widget.accounts.length),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'All Accounts',
                        style: PrimaryTextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0x4DFFFFFF),
                        child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
