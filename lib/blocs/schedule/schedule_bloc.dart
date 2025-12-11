import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/status.const.dart';
import '../../data/models/bulk_payment/bulk_payment_group_payees.dart';
import '../../data/models/process_request.model.dart';
import '../../data/models/response.modal.dart';
import '../../data/models/schedule/schedules.dart';
import '../../data/repository/schedule.repo.dart';
import '../../ui/pages/schedules/schedules.page.dart';
import '../../utils/response.util.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc
    extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on(_onRetrieveSchedules);
    on(_onSilentRetrieveSchedules);
    on(_onDeleteSchedule);
    on(_onAddSchedule);
  }

  final _repo = ScheduleRepo();
  Response<SchedulesData> schedulesData = const Response(
    code: '',
    status: '',
    message: '',
    data: null,
  );
  Map<String, Response<dynamic>> groupMembers = {};

  Future<void> _onRetrieveSchedules(
    RetrieveSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    Response<SchedulesData>? stored;

    try {
      var onSilentMode = false;
      if (schedulesData.data?.schedules?.isNotEmpty ??
          false) {
        emit(
          SchedulesRetrieved(
            result: schedulesData,
            routeName: event.routeName,
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 200),
        );
        emit(SilentRetrievingSchedules(event.routeName));
        onSilentMode = true;
      } else {
        emit(RetrievingSchedules(event.routeName));
      }

      stored = await _repo.getStoredSchedules();
      final isCurrentSchedulesEmpty =
          schedulesData.data?.schedules?.isNotEmpty ??
          false;
      if (stored == null ||
          (stored.data?.schedules?.isEmpty ?? true)) {
        schedulesData = Response(
          code: '',
          status: StatusConstants.success,
          message: 'retrieved',
          data: SchedulesData(),
        );
      } else if (stored.data?.schedules?.isNotEmpty ??
          false) {
        schedulesData = stored;
      }

      if (isCurrentSchedulesEmpty) {
        if (onSilentMode) {
          emit(
            SchedulesRetrievedSilently(
              result: schedulesData,
              routeName: event.routeName,
            ),
          );
        } else {
          emit(
            SchedulesRetrieved(
              result: schedulesData,
              routeName: event.routeName,
            ),
          );
        }

        await Future.delayed(
          const Duration(milliseconds: 200),
        );
        emit(SilentRetrievingSchedules(event.routeName));
      }

      final result = await _repo.retrieveSchedules();

      if (result.data?.schedules?.isNotEmpty ?? false) {
        schedulesData = result;
      }

      if (stored == null ||
          (stored.data?.schedules?.isEmpty ?? false)) {
        emit(
          SchedulesRetrieved(
            result: result,
            routeName: event.routeName,
          ),
        );
      } else {
        emit(
          SchedulesRetrievedSilently(
            result: result,
            routeName: event.routeName,
          ),
        );
      }
    } catch (ex) {
      if (stored == null ||
          (stored.data?.schedules?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrieveSchedulesError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrieveSchedulesError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      }
    }
  }

  Future<void> _onSilentRetrieveSchedules(
    SilentRetrieveSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(SilentRetrievingSchedules(event.routeName));
      final result = await _repo.retrieveSchedules();
      schedulesData = result;
      emit(
        SchedulesRetrievedSilently(
          result: result,
          routeName: event.routeName,
        ),
      );
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrieveSchedulesError(
            result: error,
            routeName: event.routeName,
          ),
        ),
      );
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(DeletingSchedule(event.routeName));

      final result = await _repo.deleteSchedule(
        event.scheduleId,
      );
      if (schedulesData.data != null) {
        schedulesData = Response(
          code: schedulesData.code,
          status: schedulesData.status,
          message: schedulesData.message,
          data: schedulesData.data!.copyWith(
            schedules: result.data,
          ),
        );
      }
      emit(
        SchedulesRetrieved(
          result: schedulesData,
          routeName: event.routeName,
        ),
      );

      emit(
        ScheduleDeleted(
          result: result,
          routeName: event.routeName,
        ),
      );
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          DeleteScheduleError(
            result: error,
            routeName: event.routeName,
          ),
        ),
      );
    }
  }

  Future<void> _onAddSchedule(
    AddSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(AddingSchedule(event.routeName));

      final stored = await _repo.addSchedule(
        request: event.request,
        payload: event.payload,
        schedulePayload: event.schedulePayload,
      );

      emit(
        ScheduleAdded(
          result: stored,
          routeName: event.routeName,
        ),
      );

      await _onRetrieveSchedules(
        RetrieveSchedules(SchedulesPage.routeName),
        emit,
      );
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) {
        emit(
          AddScheduleError(
            result: error,
            routeName: event.routeName,
          ),
        );
      });

      await _onRetrieveSchedules(
        RetrieveSchedules(SchedulesPage.routeName),
        emit,
      );
    }
  }
}
