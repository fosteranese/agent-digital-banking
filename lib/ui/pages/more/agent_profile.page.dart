import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/ui/components/icon.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class AgentProfilePage extends StatefulWidget {
  const AgentProfilePage({super.key, required this.agent});
  static const routeName = '/more/agent-profile';
  final Agent agent;

  @override
  State<AgentProfilePage> createState() => _AgentProfilePageState();
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MainLayout(
          backgroundColor: Colors.white,
          showBackBtn: true,
          showNavBarOnPop: true,
          title: 'Agent Profile',
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const .all(30),
                color: ThemeUtil.highlight,
                // height: 10,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 47.5,
                      backgroundColor: ThemeUtil.iconBg,
                      child: Text(
                        StringUtil.getInitials(widget.agent.fullName!),
                        style: const TextStyle(
                          color: ThemeUtil.color3,
                          fontWeight: .w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.agent.fullName ?? '',
                      textAlign: .center,
                      style: PrimaryTextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: ThemeUtil.black,
                      ),
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      'Agent Code: ${widget.agent.agentCode}',
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
              sliver: Column(
                children: [
                  ReceiptItem(label: 'Phone Number', name: widget.agent.phoneNumber ?? ''),
                  Divider(color: ThemeUtil.border, thickness: 1, indent: 40),

                  ReceiptItem(label: 'Email Address', name: widget.agent.email ?? ''),
                  Divider(color: ThemeUtil.border, thickness: 1, indent: 40),

                  ReceiptItem(label: 'Ghana Card Details', name: widget.agent.nationalId ?? ''),
                  Divider(color: ThemeUtil.border, thickness: 1, indent: 40),

                  ReceiptItem(label: 'Primary Account', name: widget.agent.primaryAccount ?? ''),
                  Divider(color: ThemeUtil.border, thickness: 1, indent: 40),

                  ReceiptItem(label: 'Float Account', name: widget.agent.floatAccount ?? ''),
                  Divider(color: ThemeUtil.border, thickness: 1, indent: 40),
                ],
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
    if (AppUtil.currentUser!.profilePicture?.isEmpty ?? true) {
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
        backgroundImage: MemoryImage(base64Decode(AppUtil.currentUser!.profilePicture!)),
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
        style: PrimaryTextStyle(color: ThemeUtil.grey, fontSize: 14, fontWeight: .w400),
      ),
      subtitle: Text(
        name,
        style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 16, fontWeight: .w600),
      ),
      trailing: trailing,
    );
  }
}
