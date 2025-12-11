import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_category.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/user_response/activity.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/ui/components/item.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/more/profile.page.dart';
import 'package:agent_digital_banking/ui/pages/more/security_settings.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/enquiry_flow.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/utils/help.util.dart';
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
    context.read<RetrieveDataBloc>().add(RetrieveCategories(activityId: _action, endpoint: 'FBLOnline/categories/0FDC593E-89F2-4950-A491-75C66749BBCC', id: _id, action: _action, skipSavedData: skipSavedData, activityType: ActivityTypesConst.fblOnline));
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      onBackPressed: () {
        context.replace(DashboardPage.routeName);
      },
      refreshController: _refreshController,
      backIcon: IconButton(
        style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
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
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        sliver: SliverList.list(
          children: [
            Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Item(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.push(ProfilePage.routeName);
                    },
                    title: 'Profile',
                    icon: SvgPicture.asset('assets/img/face.svg', colorFilter: ColorFilter.mode(Color(0xffF4B223), BlendMode.srcIn)),
                  ),
                  _divider,
                  Item(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.push(SecuritySettingsPage.routeName);
                    },
                    title: 'Security',
                    icon: SvgPicture.asset('assets/img/security.svg', colorFilter: ColorFilter.mode(Color(0xffF4B223), BlendMode.srcIn)),
                  ),
                  _divider,
                  Item(
                    padding: EdgeInsets.zero,
                    onPressed: () => HelpUtil.show(onCancelled: () {}),
                    title: 'Help',
                    icon: SvgPicture.asset('assets/img/help.svg', colorFilter: ColorFilter.mode(Color(0xffF4B223), BlendMode.srcIn)),
                  ),
                ],
              ),
            ),

            BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
              listener: (context, state) {
                if (state is! RetrievingData && state.id == _id) {
                  MainLayout.stopRefresh(context);
                  return;
                }
              },
              builder: (context, state) {
                if (state is DataRetrieved && state.data is Response<GeneralFlowCategory> && state.id == _id) {
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
                      _divider,
                      ..._list
                          .map((form) {
                            final list = <Widget>[];

                            list.add(
                              Item(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  switch (form.activityType) {
                                    case ActivityTypesConst.enquiry:
                                      context.push(EnquiryFlowPage.routeName, extra: {'form': form});
                                      break;

                                    default:
                                      context.push(
                                        ProcessFormPage.routeName,
                                        extra: {
                                          'form': form,
                                          'amDoing': AmDoing.transaction,
                                          'activity': ActivityDatum(
                                            activity: Activity(activityId: _action, activityType: form.activityType),
                                            imageDirectory: _imageDirectory,
                                          ),
                                        },
                                      );
                                      break;
                                  }
                                },
                                title: form.formName ?? '',
                                subtitle: form.description ?? '',
                                icon: CachedNetworkImage(
                                  imageUrl: '$_imageBaseUrl$_imageDirectory/${form.icon}',
                                  width: 25,
                                  height: 25,
                                  placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                                  errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                                ),
                              ),
                            );

                            list.add(_divider);

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
    );
  }

  Widget get _divider {
    return Divider(color: Color(0xffF8F8F8));
  }
}
