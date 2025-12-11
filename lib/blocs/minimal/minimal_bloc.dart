import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/minimal_response.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/minimal.repo.dart';
import '../../utils/response.util.dart';

part 'minimal_event.dart';
part 'minimal_state.dart';

class MinimalBloc extends Bloc<MinimalEvent, MinimalState> {
  MinimalBloc() : super(const StartingNewSession()) {
    on(_onStartNewSession);
    on(_onSendReplySession);
  }

  final _repo = MinimalRepo();

  Future<void> _onStartNewSession(
    StartNewSession event,
    Emitter<MinimalState> emit,
  ) async {
    try {
      emit(const StartingNewSession());

      final result = await _repo.startNewSession();

      emit(NewSessionStarted(result));
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) => emit(StartSessionError(error)),
      );
    }
  }

  Future<void> _onSendReplySession(
    SendReplySession event,
    Emitter<MinimalState> emit,
  ) async {
    try {
      emit(
        ReplyingSession(id: event.id, reply: event.reply),
      );

      final result = await _repo.replySession(
        reply: event.reply,
        session: event.session,
      );

      emit(SessionReplied(id: event.id, result: result));
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) => emit(
          ReplySessionError(id: event.id, result: error),
        ),
      );
    }
  }
}
