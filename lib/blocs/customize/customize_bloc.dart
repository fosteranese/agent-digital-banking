import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/initialization_response.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/customize.repo.dart';
import '../../logger.dart';
import '../../utils/app.util.dart';
import '../../utils/response.util.dart';

part 'customize_event.dart';
part 'customize_state.dart';

class CustomizeBloc extends Bloc<CustomizeEvent, CustomizeState> {
  CustomizeBloc() : super(CustomizeInitial()) {
    on(_onToggleShowOnDashboard);
  }

  final _repo = CustomizeRepo();
  InitializationResponse? data;

  Future<void> _onToggleShowOnDashboard(
    ToggleShowOnDashboardEvent event,
    Emitter<CustomizeState> emit,
  ) async {
    try {
      emit(TogglingShowOnDashboard(event.activityId));

      final result = await _repo.toggleShowOnDashboard(
        activityId: event.activityId,
        status: event.status,
      );

      final status = result ? 1 : 0;
      AppUtil.currentUser = AppUtil.currentUser.copyWith(
        activities: AppUtil.currentUser.activities!.map((e) {
          if (e.activity!.activityId != event.activityId) {
            return e;
          }
          return e.copyWith(activity: e.activity!.copyWith(showOnDashboard: status));
        }).toList(),
      );

      if (AppUtil.currentUser.scanToPay!.activity!.activityId == event.activityId) {
        AppUtil.currentUser = AppUtil.currentUser.copyWith(
          scanToPay: AppUtil.currentUser.scanToPay!.copyWith(
            activity: AppUtil.currentUser.scanToPay!.activity!.copyWith(showOnDashboard: status),
          ),
        );
        // AppUtil.currentUser.scanToPay!.activity!.copyWith(
        //   showOnDashboard: status,
        // );
      }

      emit(ShowOnDashboardToggled(status: result, activityId: event.activityId));
    } catch (error) {
      logger.e(error);
      ResponseUtil.handleException(error, (error) => emit(ToggleShowOnDashboardError(error)));
    }
  }
}
