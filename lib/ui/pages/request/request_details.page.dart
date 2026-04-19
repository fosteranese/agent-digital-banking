import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/data/models/agent_collection_model.dart';

import 'package:my_sage_agent/ui/components/history/collection_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/ui/components/tab_header_2.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({super.key});
  static const routeName = '/request-details';

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  String _id = '';
  final _filterBy = ValueNotifier('collections');

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
      onRefresh: () async {},
      title: '',

      slivers: [
        SliverPadding(
          padding: const .only(top: 0, left: 20, right: 20),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const .only(top: 20, bottom: 10),
                  child: Text(
                    'Reversal Request',
                    style: TextStyle(fontSize: 24, fontWeight: .w600, color: Colors.black),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: MyHeaderDelegate(
                  maxHeight: 55,
                  minHeight: 55,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return MyTabHeader2(
                      controller: _filterBy,
                      tabItems: [
                        TabItem(title: 'Details', id: 'details'),
                        TabItem(title: 'Customer Info', id: 'customer-info'),
                        TabItem(title: 'Agent Info', id: 'agent-info'),
                      ],
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _filterBy,
                builder: (context, value, child) {
                  if (value == "details") {
                    return Column(
                      children: [
                        SummaryTile(
                          label: 'Amount',
                          value: 'GHS 200.00',
                          verticalPadding: ''.isEmpty ? 8 : 5,
                        ),
                      ],
                    );
                  }

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: .symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Pending Requests',
                                  style: const PrimaryTextStyle(
                                    fontSize: 16,
                                    fontWeight: .w600,
                                    color: ThemeUtil.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'See all',
                                  style: PrimaryTextStyle(
                                    fontSize: 14,
                                    fontWeight: .normal,
                                    color: ThemeUtil.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList.separated(
                        itemCount: 10,
                        itemBuilder: (_, index) {
                          final record = AgentCollectionModel(
                            serviceName: 'MTN Mobile Money',
                            amount: 200,
                          );
                          return CollectionItem(
                            key: ValueKey('request-item-$index'),
                            record: record,
                            onTap: null,
                          );
                        },
                        separatorBuilder: (_, _) =>
                            Divider(thickness: 1, color: ThemeUtil.headerBackground, height: 0),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
      floatingActionButtonLocation: .endDocked,
      floatingActionButtonMargin: 0,
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed: () {},
        shape: CircleBorder(),
        backgroundColor: ThemeUtil.primaryColor,
        child: SvgPicture.asset(
          'assets/img/send-feedback.svg',
          width: 23,
          colorFilter: .mode(Colors.white, .srcIn),
        ),
      ),
    );
  }

  Widget get _divider {
    return Divider(color: ThemeUtil.border, indent: 40);
  }
}
