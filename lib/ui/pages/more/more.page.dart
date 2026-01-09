import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/icon.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/ui/pages/more/security_settings.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/enquiry_flow.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});
  static const routeName = '/more';

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late List<GeneralFlowForm> _list = [];
  String _imageBaseUrl = '';
  String _imageDirectory = '';
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  String _id = '';
  final String _action = '0FDC593E-89F2-4950-A491-75C66749BBCC';

  @override
  void initState() {
    _load(skipSavedData: false);
    super.initState();
  }

  void _load({required bool skipSavedData}) {
    _id = Uuid().v4();
    context.read<RetrieveDataBloc>().add(
      RetrieveCategories(
        activityId: _action,
        endpoint: 'FBLOnline/categories/0FDC593E-89F2-4950-A491-75C66749BBCC',
        id: _id,
        action: _action,
        skipSavedData: skipSavedData,
        activityType: ActivityTypesConst.fblOnline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      onBackPressed: () {
        context.replace(DashboardPage.routeName);
      },
      refreshController: _refreshController,
      backIcon: IconButton(
        style: IconButton.styleFrom(
          fixedSize: const Size(35, 35),
          backgroundColor: const Color(0x91F7C15A),
        ),
        onPressed: () {
          context.replace(DashboardPage.routeName);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      showBackBtn: true,
      onRefresh: () async {
        _load(skipSavedData: true);
      },
      title: 'More',
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const .all(20),
            padding: const .symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: ThemeUtil.highlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                context.push(ProfilePage.routeName);
              },
              leading: ProfilePicture(radius: 20, margin: 3),
              title: Text(
                AppUtil.currentUser.user?.name ?? 'Agent Name',
                style: PrimaryTextStyle(fontSize: 16, fontWeight: .w500, color: ThemeUtil.black),
              ),
              subtitle: Text(
                'Agent Code: ${AppUtil.currentUser.user?.walletNumber ?? 'N/A'}',
                style: PrimaryTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ThemeUtil.flat,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffC4C4C4)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.maxFinite,
            margin: const .symmetric(horizontal: 20),
            padding: const .symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              border: .all(color: ThemeUtil.border),
            ),
            child: Column(
              children: [
                MoreTitle(
                  title: 'My Commission',
                  icon: 'assets/img/commissions.svg',
                  onTap: () {
                    context.push(QuickActionsPage.routeName);
                  },
                ),
                _divider,
                MoreTitle(
                  icon: 'assets/img/security.svg',
                  title: 'Security',
                  onTap: () {
                    context.push(SecuritySettingsPage.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: .only(top: 20, left: 20, right: 20, bottom: 10),
            child: Text(
              'Help Center',
              style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.black),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.maxFinite,
            margin: const .symmetric(horizontal: 20),
            padding: const .symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              border: .all(color: ThemeUtil.border),
            ),
            child: Column(
              children: [
                MoreTitle(
                  title: 'Email',
                  icon: 'assets/img/mail.svg',
                  onTap: () {
                    final url = Uri.parse('mailto:${AppUtil.data.help?.email}');
                    launchUrl(url);
                  },
                ),
                _divider,
                MoreTitle(
                  title: 'Call Us',
                  icon: 'assets/img/call-us.svg',
                  onTap: () {
                    final url = Uri.parse('tel:${AppUtil.data.help?.phoneNumber}');
                    launchUrl(url);
                  },
                ),
                BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
                  listener: (context, state) {
                    if (state is! RetrievingData && state.id == _id) {
                      MainLayout.stopRefresh(context);
                      return;
                    }
                  },
                  builder: (context, state) {
                    if (state is DataRetrieved &&
                        state.data is Response<GeneralFlowCategory> &&
                        state.id == _id) {
                      final response = state.data;

                      _imageBaseUrl = response.imageBaseUrl ?? '';
                      _imageDirectory = response.imageDirectory ?? '';
                      _list = response.data?.forms ?? [];
                    }

                    return Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      margin: const EdgeInsets.only(top: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ..._list
                              .map((form) {
                                final list = <Widget>[_divider];

                                list.add(
                                  MoreTitle(
                                    title: form.formName ?? '',
                                    icon: '$_imageBaseUrl$_imageDirectory/${form.icon}',
                                    onTap: () {
                                      switch (form.activityType) {
                                        case ActivityTypesConst.enquiry:
                                          context.push(
                                            EnquiryFlowPage.routeName,
                                            extra: {'form': form},
                                          );
                                          break;

                                        default:
                                          context.push(
                                            ProcessFormPage.routeName,
                                            extra: {
                                              'form': form,
                                              'amDoing': AmDoing.transaction,
                                              'activity': ActivityDatum(
                                                activity: Activity(
                                                  activityId: _action,
                                                  activityType: form.activityType,
                                                ),
                                                imageDirectory: _imageDirectory,
                                              ),
                                            },
                                          );
                                          break;
                                      }
                                    },
                                  ),
                                );

                                return list;
                              })
                              .expand((element) => element),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Container(
            width: double.maxFinite,
            margin: const .symmetric(horizontal: 20, vertical: 20),
            padding: const .symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              border: .all(color: ThemeUtil.border),
            ),
            child: Column(
              children: [
                MoreTitle(
                  iconColor: ThemeUtil.danger,
                  iconBackgroundColor: const Color(0xffFFF1F1),
                  title: 'Sign Out',
                  icon: 'assets/img/logout.svg',
                  onTap: () {
                    AppUtil.logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _divider {
    return Divider(color: ThemeUtil.border, indent: 40);
  }
}

class MoreTitle extends StatelessWidget {
  const MoreTitle({
    super.key,
    this.onTap,
    required this.title,
    required this.icon,
    this.iconColor = ThemeUtil.primaryColor,
    this.iconBackgroundColor = ThemeUtil.highlight,
  });
  final void Function()? onTap;
  final String title;
  final String icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: .zero,
      leading: MyIcon(icon: icon, iconColor: iconColor!, iconBackgroundColor: iconBackgroundColor!),

      title: Text(
        title,
        style: PrimaryTextStyle(fontSize: 16, fontWeight: .w400, color: ThemeUtil.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffC4C4C4)),
    );
  }
}
