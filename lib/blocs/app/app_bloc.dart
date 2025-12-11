import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/initialization_response.dart';
import '../../data/models/response.modal.dart';
import '../../data/models/user_response/user_response.dart';
import '../../data/repository/app.repo.dart';
import '../../logger.dart';
import '../../utils/app.util.dart';
import '../../utils/response.util.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on(_onDeviceStatusCheck);
    on(_onSilenceDeviceCheck);
    on(_onAppError);
    on(_onCheckDeviceSecurity);
    on(_onSetScheduleStatus);
  }

  final _repo = AppRepo();
  InitializationResponse? data;
  bool scheduleTransaction = false;

  Future<void> _onDeviceStatusCheck(
    DeviceStatusCheckEvent event,
    Emitter<AppState> emit,
  ) async {
    InitializationResponse? initial;
    UserResponse? currentUser;

    try {
      emit(CheckingDeviceStatus());

      final threat = await AppUtil.isThreatFound();
      if (threat != null) {
        emit(AppError(threat));
        return;
      }

      await Future.wait([
        AppUtil.deviceCheck(),
        AppUtil.getInfo(),
      ]);

      final response = await Future.wait([
        _repo.getCurrentUser(),
        _repo.getInitialData(),
      ]);
      currentUser = response.first as UserResponse?;
      initial = response.last as InitializationResponse?;

      if (initial != null) {
        data = initial;
        AppUtil.data = initial;

        if (currentUser != null) {
          AppUtil.currentUser = currentUser;
          emit(UserExistOnDevice());
        } else {
          emit(ExistingDevice());
        }
        _repo.initiateDevice().then((value) {
          data = value;
          AppUtil.data = value;
        });
        // return;
      }

      final newInitial = await _repo.initiateDevice();

      data = newInitial;
      AppUtil.data = newInitial;

      if (initial == null) {
        emit(NewDevice());
      }
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) => emit(AppError(error)),
      );
      if (initial == null) {}
    }
  }

  void _onAppError(
    RaiseSecurityThreadEvent event,
    Emitter<AppState> emit,
  ) {
    emit(CheckingDeviceStatus());

    emit(AppError(event.error));
  }

  void _onCheckDeviceSecurity(
    CheckDeviceSecurityEvent event,
    Emitter<AppState> emit,
  ) {
    // AppUtil.configSecurity();
  }

  Future<void> _onSilenceDeviceCheck(
    SilentDeviceCheckEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      // await AppUtil.deviceCheck();
    } catch (error) {
      logger.e(error);
      ResponseUtil.handleException(
        error,
        (error) => emit(AppError(error)),
      );
    }
  }

  void _onSetScheduleStatus(
    SetScheduleStatusEvent event,
    Emitter<AppState> emit,
  ) {
    scheduleTransaction = event.status;
  }
}
