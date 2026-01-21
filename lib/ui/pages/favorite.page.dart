import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/collection/collection_bloc.dart';
import '../../blocs/general_flow/general_flow_bloc.dart';
import '../../data/models/user_response/recent_activity.dart';
import '../../utils/app.util.dart';
import '../../utils/service.util.dart';
import '../components/form/search_box.dart';
import '../components/item.dart';
import '../layouts/main.layout.dart';
import 'quick_actions.page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  static const routeName = '/favorite';

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _controller = TextEditingController();
  List<RecentActivity> _activities = [];

  @override
  void initState() {
    _activities = AppUtil.currentUser.recentActivity ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentsBloc, PaymentsState>(
          listener: (context, state) => ServiceUtil.paymentsListener(
            context: context,
            state: state,
            routeName: FavoritePage.routeName,
            amDoing: AmDoing.transaction,
          ),
        ),
        BlocListener<GeneralFlowBloc, GeneralFlowState>(
          listener: (context, state) => ServiceUtil.generalFlowListener(
            context: context,
            state: state,
            routeName: FavoritePage.routeName,
            amDoing: AmDoing.transaction,
          ),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MainLayout(
            showBackBtn: true,
            title: 'Pay again',
            bottom: SearchBox(
              controller: _controller,
              onSearch: (value) => _search(value, AppUtil.currentUser.recentActivity!),
            ),
            sliver: (state is LoggedIn)
                ? SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: MultiBlocListener(
                        listeners: ServiceUtil.onShortcutListeners(
                          routeName: FavoritePage.routeName,
                          amDoing: AmDoing.transaction,
                        ),
                        child: ListView.separated(
                          itemCount: _activities.length,
                          itemBuilder: (context, index) {
                            final activity = _activities[index];
                            return Item(
                              onPressed: () {
                                ServiceUtil.onFavoritePressed(
                                  activity: activity,
                                  context: context,
                                  routeName: FavoritePage.routeName,
                                );
                              },
                              title: activity.formName ?? '',
                              subtitle: activity.activityName,
                              icon: CachedNetworkImage(
                                imageUrl:
                                    activity.iconPath ??
                                    '${state.user.imageBaseUrl}${state.user.imageDirectory}/${activity.icon}',
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(backgroundImage: imageProvider),
                                width: 32,
                                placeholder: (context, url) => Icon(
                                  Icons.circle_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.circle_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const Divider(color: Color(0xffF1F1F1), indent: 60),
                        ),
                      ),
                    ),
                  )
                : null,
            child: (state is! LoggedIn)
                ? const Center(child: CircularProgressIndicator.adaptive())
                : null,
          );
        },
      ),
    );
  }

  void _search(String value, List<RecentActivity> activities) {
    setState(() {
      _activities = activities.where((element) {
        String search = value.trim().toLowerCase();
        return (element.formName?.toLowerCase().contains(search) ?? false) ||
            (element.activityName?.toLowerCase().contains(search) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
