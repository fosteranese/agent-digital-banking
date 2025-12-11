import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response.modal.dart';
import '../../data/models/verify_ghana_card_response.dart';
import '../../data/repository/auth.repo.dart';
import '../../utils/response.util.dart';

part 'ghana_card_event.dart';
part 'ghana_card_state.dart';

class GhanaCardBloc
    extends Bloc<GhanaCardEvent, GhanaCardState> {
  GhanaCardBloc() : super(CompleteGhanaCardInitial()) {
    on(_onVerifyCompleteGhanaCard);
    on(_onReVerifyCompleteGhanaCard);
  }

  final _repo = AuthRepo();
  String picture = '';
  String code = '';

  // verify ghana card
  Future<void> _onVerifyCompleteGhanaCard(
    VerifyCompleteGhanaCard event,
    Emitter<GhanaCardState> emit,
  ) async {
    try {
      emit(VerifyingCompleteGhanaCard());
      picture = event.image;
      code = event.code;
      final result = await _repo.verifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(
        CompleteGhanaCardVerified(
          data: result,
          resendPayload: event.registrationId,
        ),
      );
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) =>
            emit(VerifyCompleteGhanaCardError(error)),
      );
    }
  }

  // re-verify ghana card
  Future<void> _onReVerifyCompleteGhanaCard(
    ReVerifyCompleteGhanaCard event,
    Emitter<GhanaCardState> emit,
  ) async {
    try {
      emit(ReVerifyingCompleteGhanaCard());
      final result = await _repo.verifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(
        CompleteGhanaCardReVerified(
          data: result,
          resendPayload: event.registrationId,
        ),
      );
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) =>
            emit(ReVerifyCompleteGhanaCardError(error)),
      );
    }
  }
}
