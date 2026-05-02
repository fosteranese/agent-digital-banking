import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/activity_service_request_model/record.dart';
import 'package:my_sage_agent/data/models/agent_collection_model.dart';
import 'package:my_sage_agent/data/models/commission_model.dart';
import 'package:my_sage_agent/data/models/reversal_request_model/reversal_request_model.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/history/agent_details_filter_sheet.dart';
import 'package:my_sage_agent/ui/components/history/collection_item.dart';
import 'package:my_sage_agent/ui/components/history/commission_list_item.dart';
import 'package:my_sage_agent/ui/components/history/supervisor_agent_reversal_item.dart';
import 'package:my_sage_agent/ui/components/history/supervisor_agent_history_list_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/ui/components/tab_header_2.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/collections/collections_details.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/more/agent_profile.page.dart';
import 'package:my_sage_agent/ui/pages/request/reversal_details.page.dart';
import 'package:my_sage_agent/ui/pages/team/supervisor_agent_collections.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum SupervisorAgentListTypes { collections, reversals, activities, commissions }

class AgentDetailsPage extends StatefulWidget {
  const AgentDetailsPage({super.key, required this.agent});
  static const routeName = '/agent-details';

  final Agent agent;

  @override
  State<AgentDetailsPage> createState() => _AgentDetailsPageState();
}

class _AgentDetailsPageState extends State<AgentDetailsPage> {
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  final _filterBy = ValueNotifier(SupervisorAgentListTypes.collections.name);
  final _startDateCollectionDate = TextEditingController();
  final _endDateCollectionDate = TextEditingController();
  final _collectionSourceList = ValueNotifier<List<AgentCollectionModel>>([]);
  final _collectionList = ValueNotifier<List<AgentCollectionModel>>([]);
  final _reversalSourceList = ValueNotifier<List<ReversalRequestModel>>([]);
  final _reversalList = ValueNotifier<List<ReversalRequestModel>>([]);
  final _activitySourceList = ValueNotifier<List<ActivityRecordModel>>([]);
  final _activityList = ValueNotifier<List<ActivityRecordModel>>([]);
  final _commissionSourceList = ValueNotifier<List<CommissionModel>>([]);
  final _commissionList = ValueNotifier<List<CommissionModel>>([]);

  @override
  initState() {
    _loadCollectionsData();
    _loadReversalsData();
    _loadActivitiesData();
    _loadCommissionsData();

    super.initState();
  }

  void _loadCollectionsData() {
    context.read<RetrieveDataBloc>().add(
      RetrieveSupervisorAgentCollectionsEvent(
        id: '',
        action: 'RetrieveSupervisorAgentCollectionsEvent',
        skipSavedData: true,
        agentCode: widget.agent.agentCode.toString(),
      ),
    );
  }

  void _loadReversalsData() {
    context.read<RetrieveDataBloc>().add(
      RetrieveSupervisorAgentReversalsEvent(
        id: '',
        action: 'RetrieveSupervisorAgentReversalsEvent',
        skipSavedData: true,
        agentCode: widget.agent.agentCode.toString(),
      ),
    );
  }

  void _loadCommissionsData() {
    context.read<RetrieveDataBloc>().add(
      RetrieveSupervisorAgentCommissionsEvent(
        id: '',
        action: 'RetrieveSupervisorAgentCommissionsEvent',
        skipSavedData: true,
        agentCode: widget.agent.agentCode.toString(),
      ),
    );
  }

  void _loadActivitiesData() {
    context.read<RetrieveDataBloc>().add(
      RetrieveSupervisorAgentActivitiesEvent(
        id: '',
        action: 'RetrieveSupervisorAgentActivitiesEvent',
        skipSavedData: true,
        agentCode: widget.agent.agentCode.toString(),
      ),
    );
  }

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
      onRefresh: () async {
        _loadCollectionsData();
        _loadReversalsData();
        _loadActivitiesData();
        _loadCommissionsData();
      },
      title: 'Agent Details',
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const .all(20),
            padding: const .symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: ThemeUtil.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                context.push(AgentProfilePage.routeName, extra: widget.agent);
              },
              leading: AgentProfilePicture(
                radius: 20,
                margin: 3,
                name: widget.agent.fullName ?? 'N/A',
              ),
              title: Text(
                widget.agent.fullName ?? 'Agent Name',
                style: PrimaryTextStyle(fontSize: 16, fontWeight: .w500, color: ThemeUtil.black),
              ),
              subtitle: Text(
                'Agent Code: ${widget.agent.agentCode ?? 'N/A'}',
                style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffC4C4C4)),
            ),
          ),
        ),
        SliverPadding(
          padding: const .only(top: 0, left: 20, right: 20),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: MyHeaderDelegate(
                  maxHeight: 55,
                  minHeight: 55,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return MyTabHeader2(
                      controller: _filterBy,
                      tabItems: [
                        TabItem(
                          title: 'Collections',
                          id: SupervisorAgentListTypes.collections.name,
                        ),
                        TabItem(title: 'Reversals', id: SupervisorAgentListTypes.reversals.name),
                        TabItem(title: 'Activities', id: SupervisorAgentListTypes.activities.name),
                        TabItem(
                          title: 'Commissions',
                          id: SupervisorAgentListTypes.commissions.name,
                        ),
                      ],
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _filterBy,
                builder: (context, value, child) {
                  if (value == SupervisorAgentListTypes.collections.name) {
                    return SupervisorAgentCollections<AgentCollectionModel>(
                      key: ValueKey(SupervisorAgentListTypes.collections.name),
                      agent: widget.agent,
                      list: _collectionList,
                      sourceList: _collectionSourceList,
                      filter: _onShowCollectionsFilterDialog,
                      itemFunc: (record) {
                        return CollectionItem(
                          record: record,
                          onTap: () {
                            context.push(CollectionsDetailsPage.routeName, extra: record);
                          },
                        );
                      },
                      emptyListMessageTitle: 'No collections found',
                      emptyListMessageFunc: (filter) =>
                          'No collections match the search phrase "$filter".',
                      search: (String value, List<AgentCollectionModel> requests) {
                        final search = value.trim().toLowerCase();
                        _collectionList.value = requests.where((e) {
                          return (e.customerName?.toLowerCase().contains(search) ?? false) ||
                              (e.serviceName?.toString().toLowerCase().contains(search) ?? false);
                        }).toList();
                      },
                      conditionFunc: (event) => event is RetrieveSupervisorAgentCollectionsEvent,
                    );
                  }

                  if (value == SupervisorAgentListTypes.reversals.name) {
                    return SupervisorAgentCollections<ReversalRequestModel>(
                      key: ValueKey(SupervisorAgentListTypes.reversals.name),
                      agent: widget.agent,
                      list: _reversalList,
                      sourceList: _reversalSourceList,
                      filter: _onShowCollectionsFilterDialog,
                      itemFunc: (record) {
                        return SupervisorAgentReversalItem(
                          record: record,
                          onTap: () {
                            context.push(ReversalDetailsPage.routeName, extra: record);
                          },
                        );
                      },
                      emptyListMessageTitle: 'No reversals found',
                      emptyListMessageFunc: (filter) =>
                          'No reversals match the search phrase "$filter".',
                      search: (String value, List<ReversalRequestModel> requests) {
                        _reversalList.value = _reversalSourceList.value;
                      },
                      conditionFunc: (event) => event is RetrieveSupervisorAgentReversalsEvent,
                    );
                  }

                  if (value == SupervisorAgentListTypes.activities.name) {
                    return SupervisorAgentCollections<ActivityRecordModel>(
                      key: ValueKey(SupervisorAgentListTypes.activities.name),
                      agent: widget.agent,
                      list: _activityList,
                      sourceList: _activitySourceList,
                      filter: _onShowCollectionsFilterDialog,
                      itemFunc: (record) {
                        return SupervisorAgentHistoryListItem(
                          record: record,
                          onTap: () {
                            context.push(CollectionsDetailsPage.routeName, extra: record);
                          },
                        );
                      },
                      emptyListMessageTitle: 'No activities found',
                      emptyListMessageFunc: (filter) =>
                          'No activities match the search phrase "$filter".',
                      search: (String value, List<ActivityRecordModel> requests) {
                        final search = value.trim().toLowerCase();
                        _activityList.value = requests.where((e) {
                          return (e.customerName?.toLowerCase().contains(search) ?? false) ||
                              (e.serviceName?.toString().toLowerCase().contains(search) ?? false);
                        }).toList();
                      },
                      conditionFunc: (event) => event is RetrieveSupervisorAgentActivitiesEvent,
                    );
                  }

                  return SupervisorAgentCollections<CommissionModel>(
                    key: ValueKey(SupervisorAgentListTypes.commissions.name),
                    agent: widget.agent,
                    list: _commissionList,
                    sourceList: _commissionSourceList,
                    filter: _onShowCollectionsFilterDialog,
                    itemFunc: (record) {
                      return CommissionListItem(
                        record: record,
                        onTap: () {
                          context.push(CollectionsDetailsPage.routeName, extra: record);
                        },
                      );
                    },
                    emptyListMessageTitle: 'No commissions found',
                    emptyListMessageFunc: (filter) =>
                        'No commissions match the search phrase "$filter".',
                    search: (String value, List<CommissionModel> requests) {
                      final search = value.trim().toLowerCase();
                      _commissionList.value = requests.where((e) {
                        return (e.serviceName?.toString().toLowerCase().contains(search) ?? false);
                      }).toList();
                    },
                    conditionFunc: (event) => event is RetrieveSupervisorAgentCommissionsEvent,
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

  void _onShowCollectionsFilterDialog() {
    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => AgentDetailsFilterSheet(
        dateFrom: _startDateCollectionDate,
        dateTo: _endDateCollectionDate,
        onFilterSelected: (dateFrom, dateTo) {
          _collectionList.value = [];

          if (_filterBy.value == SupervisorAgentListTypes.collections.name) {
            _loadCollectionsData();
          } else if (_filterBy.value == SupervisorAgentListTypes.reversals.name) {
            _loadReversalsData();
          } else if (_filterBy.value == SupervisorAgentListTypes.activities.name) {
            _loadActivitiesData();
          } else if (_filterBy.value == SupervisorAgentListTypes.commissions.name) {
            _loadCommissionsData();
          }
        },
        onClearFilter: () {
          _startDateCollectionDate.text = '';
          _endDateCollectionDate.text = '';

          if (_filterBy.value == SupervisorAgentListTypes.collections.name) {
            _loadCollectionsData();
          } else if (_filterBy.value == SupervisorAgentListTypes.reversals.name) {
            _loadReversalsData();
          } else if (_filterBy.value == SupervisorAgentListTypes.activities.name) {
            _loadActivitiesData();
          } else if (_filterBy.value == SupervisorAgentListTypes.commissions.name) {
            _loadCommissionsData();
          }
        },
      ),
    );
  }
}
