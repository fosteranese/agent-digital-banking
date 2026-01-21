import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/data/models/push_notification.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/ui/components/form/search_box.dart';
import 'package:my_sage_agent/ui/components/list_loading_shimmer_.cm.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class PushNotificationsPage extends StatefulWidget {
  const PushNotificationsPage({super.key});
  static const routeName = '/notifications';
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<PushNotificationsPage> createState() => _PushNotificationsPageState();
}

class _PushNotificationsPageState extends State<PushNotificationsPage> {
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  final _controller = TextEditingController();
  List<PushNotification> _sourceList = [];
  List<PushNotification> _list = [];
  final formatter = DateFormat('dd MMM');
  final fullFormatter = DateFormat('dd MMM, yy HH:mm');
  late Timer _timer;

  @override
  void initState() {
    context.read<PushNotificationBloc>().add(const LoadPushNotification());
    _sourceList = [];
    _list = [];
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _sourceList.where((element) => element.read == false).forEach((element) {
        context.read<PushNotificationBloc>().add(ReadPushNotification(element));
      });
    });
  }

  bool _showSearchBox = false;

  Map<String, bool> _expanded = {};

  (List<PushNotification>, List<PushNotification>) get _separatedList {
    return (
      _list.where((item) => item.read != true).toList(),
      _list.where((item) => item.read == true).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Color(0xffF8F8F8),
      showBackBtn: true,
      title: 'Notification',
      refreshController: _refreshController,
      onRefresh: () async {
        context.read<PushNotificationBloc>().add(const LoadPushNotification());
      },
      bottom: _showSearchBox
          ? SearchBox(controller: _controller, onSearch: (value) => _search(value, _sourceList))
          : null,
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            fixedSize: const Size(35, 35),
            backgroundColor: const Color(0x91F7C15A),
          ),
          onPressed: () => setState(() => _showSearchBox = !_showSearchBox),
          icon: SvgPicture.asset(
            'assets/img/search.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 10),
      ],
      sliver: SliverPadding(
        padding: EdgeInsets.all(15),
        sliver: BlocConsumer<PushNotificationBloc, PushNotificationState>(
          listener: (context, state) {
            if (state is PushNotificationLoaded) {
              _sourceList = state.result;
              _search('', _sourceList, shouldSetState: false);

              MainLayout.stopRefresh(context);
              return;
            }

            if (state is LoadPushNotificationError) {
              MainLayout.stopRefresh(context);
              return;
            }
          },
          builder: (context, state) {
            if (state is LoadingPushNotification) {
              return SliverList.separated(
                itemBuilder: (context, index) => const ListLoadingShimmer(),
                separatorBuilder: (context, index) =>
                    const Divider(color: Color(0xffF1F1F1), indent: 60),
              );
            }

            if (state is LoadPushNotificationError) {
              return SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SvgPicture.asset(
                      //   'assets/img/server-error.svg',
                      //   width: 200,
                      // ),
                      const Text(
                        'Error loading notifications',
                        style: PrimaryTextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        state.result.message,
                        style: PrimaryTextStyle(
                          color: Color(0xff919195),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              );
            }

            if (state is! PushNotificationLoaded && state is! PushNotificationLoadedSilently) {
              return const SliverToBoxAdapter();
            }

            if (_list.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/img/empty.svg', width: 64),
                      const SizedBox(height: 10),
                      const Text(
                        'No notifications found',
                        style: PrimaryTextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Complete an activity to see it appear here',
                        style: PrimaryTextStyle(
                          color: Color(0xff919195),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              );
            }

            return MultiSliver(
              children: [
                if (_separatedList.$1.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 30),
                    sliver: SliverList.separated(
                      itemCount: _separatedList.$1.length,
                      itemBuilder: (context, index) {
                        final record = _getItem(index, _separatedList.$1);

                        return _buildNotificationTile(record, context);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  ),
                if (_separatedList.$2.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Read Notifications',
                        style: PrimaryTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                  ),
                if (_separatedList.$2.isNotEmpty)
                  SliverList.separated(
                    itemCount: _separatedList.$2.length,
                    itemBuilder: (context, index) {
                      final record = _getItem(index, _separatedList.$2);

                      return _buildNotificationTile(record, context);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Slidable _buildNotificationTile(PushNotification record, BuildContext context) {
    return Slidable(
      key: ValueKey(record.id ?? ''),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(
          onDismissed: () {
            context.read<PushNotificationBloc>().add(DeletePushNotification(record));
          },
        ),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              context.read<PushNotificationBloc>().add(DeletePushNotification(record));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          onTap: () {
            context.read<PushNotificationBloc>().add(ReadPushNotification(record));
            _expanded = _expanded.map((k, _) => MapEntry(k, false));
            _expanded[record.id ?? ''] = !(_expanded[record.id ?? ''] ?? false);
            setState(() {});
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xffF8F8F8),
            child: record.read == true
                ? SvgPicture.asset('assets/img/read-notification.svg')
                : SvgPicture.asset('assets/img/unread-notification.svg'),
          ),
          title: Text(
            record.title ?? '',
            style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          isThreeLine: true,
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.content ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: _expanded[record.id ?? ''] == true ? null : 2,

                style: PrimaryTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff54534A),
                ),
              ),
              SizedBox(height: 5),
              Text(
                fullFormatter.format(record.sentTime ?? DateTime.now()),
                style: PrimaryTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff919195),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PushNotification _getItem(int index, List<PushNotification> list) {
    return list[index];

    // return PushNotification(
    //   read: index % 3 == 0,
    //   id: Uuid().v4(),
    //   title: 'Dragon King',
    //   content:
    //       'Do you want me to also show you how to make ListTile dynamically expand to fit any number of lines of subtitle text without explicitly setting isThreeLine?',
    // );
  }

  void _search(String value, List<PushNotification> requests, {shouldSetState = true}) {
    logger.i(value);
    String search = value.trim().toLowerCase();
    _list = requests.where((element) {
      return element.title?.toLowerCase().contains(search) ?? false;
    }).toList();
    if (shouldSetState) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
