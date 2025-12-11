import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response.modal.dart';
import '../../data/repository/auth.repo.dart';
import '../../utils/response.util.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on(_onRResendOtp);
  }

  final _repo = AuthRepo();

  Future<void> _onRResendOtp(
    ResendOtp event,
    Emitter<OtpState> emit,
  ) async {
    try {
      emit(ResendingOtp(event.uid));

      final result = await _repo.resendOtp(event.formId);

      emit(OtpResent(result: result, uid: event.uid));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          ResendOtpError(result: error, uid: event.uid),
        ),
      );
    }
  }
}
