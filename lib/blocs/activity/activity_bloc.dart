import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc
    extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(OnActivityToNotify()) {
    on(_onPerformActivityEvent);
  }

  Future<void> _onPerformActivityEvent(
    PerformActivityEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActionJustPerformed());
    await Future.delayed(const Duration(seconds: 1));
    emit((ActivityAlreadyAnnounced()));
  }
}
