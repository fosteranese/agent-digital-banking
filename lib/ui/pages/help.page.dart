import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/help.dart';
import 'package:my_sage_agent/ui/components/popover.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Help',
                style: PrimaryTextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppUtil.data.help?.descrption ?? '',
            style: PrimaryTextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          HelpItem(
            iconSvg: 'assets/img/call-us.svg',
            iconColor: const Color(0x80B7861A),
            title: 'Call Us',
            onPressed: () async {
              final url = Uri.parse('tel:${AppUtil.data.help?.phoneNumber}');
              launchUrl(url);
            },
          ),
          HelpItem(
            iconSvg: 'assets/img/mail.svg',
            iconColor: const Color(0x91F7C15A),
            title: 'Email Us',
            subtitle: AppUtil.data.help?.email ?? '',
            onPressed: () {
              final url = Uri.parse('mailto:${AppUtil.data.help?.email}');
              launchUrl(url);
            },
          ),
          HelpItem(
            iconSvg: 'assets/img/terms.svg',
            iconColor: const Color(0x80B7861A),
            title: 'Terms & Conditions',
            subtitle: AppUtil.data.help?.termsUrl ?? '',
            onPressed: () {
              final url = Uri.parse(AppUtil.data.help?.termsUrl ?? '');
              launchUrl(url);
            },
          ),
          HelpItem(
            iconSvg: 'assets/img/faq.svg',
            iconColor: const Color(0x91F7C15A),
            title: 'FAQ',
            subtitle: AppUtil.data.help?.faqUrl ?? '',
            onPressed: () {
              final url = Uri.parse(AppUtil.data.help?.faqUrl ?? '');
              launchUrl(url);
            },
          ),
          HelpItem(
            icon: Icons.diversity_2_outlined,
            iconColor: const Color(0x91F7C15A),
            title: 'Social Media',
            subtitle: 'Social Media',
            onPressed: () {
              _showSocialMedia();
            },
          ),
          HelpItem(
            iconSvg: 'assets/img/whatsapp.svg',
            iconColor: const Color(0x80B7861A),
            title: 'Send Us a Whatsapp Message',
            subtitle: 'whatsapp us',
            onPressed: () {
              _launchWhatsApp(AppUtil.data.help?.whatsApp ?? '');
            },
          ),
        ],
      ),
    );
  }

  void _showSocialMedia() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: SvgPicture.asset('assets/img/x.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.twitter ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Twitter/X',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/instagram.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.instagram ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Instagram',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/tiktok.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.tikTok ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'TikTok',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/facebook.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.facebook ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Facebook',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/linkedin.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.linkedIn ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'LinkedIn',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/youtube.svg', width: 30),
                  onTap: () {
                    final url = Uri.parse(AppUtil.data.help?.social?.youTube ?? '');
                    launchUrl(url);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'YouTube',
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchWhatsApp(String phone) async {
    final uri = Uri.parse('whatsapp://send?phone=$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      MessageUtil.displayErrorDialog(context, message: 'Sorry! Could not launch Whatsapp');
    }
  }
}
