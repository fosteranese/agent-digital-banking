import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/ui/components/icon.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routeName = '/more/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final details = (AppUtil.currentUser.user!.previewData ?? []).where((element) {
      return element.key != null &&
          element.value != null &&
          element.value!.isNotEmpty &&
          element.key!.isNotEmpty;
    }).toList();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MainLayout(
          backgroundColor: Colors.white,
          showBackBtn: true,
          showNavBarOnPop: true,
          title: 'Profile',
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const .all(30),
                color: ThemeUtil.highlight,
                // height: 10,
                child: Column(
                  children: [
                    ProfilePicture(),
                    const SizedBox(height: 10),
                    Text(
                      AppUtil.currentUser.user?.name ?? '',
                      textAlign: .center,
                      style: PrimaryTextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: ThemeUtil.black,
                      ),
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      'Agent Code: ${AppUtil.currentUser.user?.walletNumber}',
                      textAlign: .center,
                      style: PrimaryTextStyle(
                        fontSize: 14,
                        fontWeight: .normal,
                        color: ThemeUtil.flat,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: details.length,
                itemBuilder: (_, index) {
                  final item = details[index];
                  if (item.key?.toLowerCase() != 'verification status') {
                    return ReceiptItem(label: item.key!, name: item.value ?? '');
                  }

                  return ReceiptItem(
                    icon: item.icon ?? '',
                    label: item.key!,
                    name: item.value ?? '',
                    trailing: item.value?.toUpperCase() != 'YES'
                        ? SizedBox(
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColorLight.withAlpha(89),
                                foregroundColor: Colors.black,
                                elevation: 0,
                              ),
                              child: const Text('Verify'),
                            ),
                          )
                        : null,
                  );
                },
                separatorBuilder: (_, _) {
                  return Divider(color: ThemeUtil.border, thickness: 1, indent: 40);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.radius = 40, this.margin = 5});
  final double radius;
  final double margin;

  @override
  Widget build(BuildContext context) {
    if (AppUtil.currentUser.profilePicture?.isEmpty ?? true) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: radius,
        child: SvgPicture.asset('assets/img/user.svg', width: double.maxFinite),
      );
    }

    return Container(
      padding: .all(margin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(radius + margin),
        // boxShadow: [
        //   BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: Offset(0, 2)),
        // ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Color(0xffD9D9D9),
        backgroundImage: MemoryImage(base64Decode(AppUtil.currentUser.profilePicture!)),
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({
    super.key,
    this.icon = '',
    required this.label,
    required this.name,
    this.trailing,
    this.valueTextAlignment = TextAlign.right,
  });

  final String icon;
  final String label;
  final String name;
  final Widget? trailing;
  final TextAlign valueTextAlignment;

  String get _icon {
    final labelLowerCase = label.toLowerCase();
    if (icon.isNotEmpty) {
      return icon;
    } else if (labelLowerCase.contains('phone') || labelLowerCase.contains('mobile')) {
      return 'assets/img/call-us.svg';
    } else if (labelLowerCase.contains('email')) {
      return 'assets/img/mail.svg';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: MyIcon(icon: _icon),
      title: Text(
        label,
        style: PrimaryTextStyle(color: ThemeUtil.grey, fontSize: 14, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        name,
        style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: trailing,
    );
  }
}
