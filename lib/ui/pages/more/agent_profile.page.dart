import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
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
                color: ThemeUtil.iconBg,
                // height: 10,
                child: Column(
                  children: [
                    AgentProfilePicture(radius: 47.5, name: widget.agent.fullName!, fontSize: 20),
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
              sliver: SliverFillRemaining(
                child: Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
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
            ),
          ],
        );
      },
    );
  }
}

class AgentProfilePicture extends StatelessWidget {
  const AgentProfilePicture({
    super.key,
    this.radius = 40,
    this.margin = 5,
    required this.name,
    this.fontSize = 14,
  });
  final double radius;
  final double margin;
  final String name;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(margin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(radius + margin),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: ThemeUtil.iconBg,
        child: Text(
          FormatterUtil.getInitials(name),
          style: TextStyle(color: ThemeUtil.color3, fontWeight: .w400, fontSize: fontSize),
        ),
      ),
    );
  }
}
