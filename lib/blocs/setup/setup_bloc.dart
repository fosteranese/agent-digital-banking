import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/account_opening_lovs.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/auth.repo.dart';
import '../../data/repository/setup.repo.dart';
import '../../utils/response.util.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(AccountInitial()) {
    on(_onRetrieveAccountOpeningLOVs);
    on(_onRetrieveAccessCode);
  }

  final _repo = SetupRepo();
  final _auth = AuthRepo();

  Response<AccountOpeningLovs> accounts = const Response(
    code: 'success',
    status: 'success',
    message: 'Retrieved',
    data: null,
  );

  Future<void> _onRetrieveAccountOpeningLOVs(
    RetrieveAccountOpeningLOVs event,
    Emitter<SetupState> emit,
  ) async {
    Response<AccountOpeningLovs>? stored;
    try {
      emit(RetrievingAccountOpeningLOVs(event.routeName));

      stored = await _repo.getStoredRetrieveAccountOpeningLOVs();

      if (stored != null &&
          (stored.data?.accountTypes?.isNotEmpty ?? false) &&
          (stored.data?.branches?.isNotEmpty ?? false)) {
        accounts = stored;
        emit(AccountOpeningLOVsRetrieved(result: accounts, routeName: event.routeName));
      }

      final result = await _repo.retrieveAccountOpeningLOVs();
      accounts = result;

      if (stored == null ||
          (stored.data?.accountTypes?.isEmpty ?? false) ||
          (stored.data?.branches?.isEmpty ?? false)) {
        emit(AccountOpeningLOVsRetrieved(result: accounts, routeName: event.routeName));
      } else {
        emit(AccountOpeningLOVsRetrievedSilently(accounts));
      }
    } catch (ex) {
      if (stored == null ||
          (stored.data?.accountTypes?.isEmpty ?? false) ||
          (stored.data?.branches?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) =>
              emit(RetrieveAccountOpeningLOVsError(result: error, routeName: event.routeName)),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(SilentRetrieveAccountOpeningLOVsError(error)),
        );
      }
    }
  }

  Future<void> _onRetrieveAccessCode(RetrieveAccessCode event, Emitter<SetupState> emit) async {
    try {
      emit(RetrievingAccessCode(event.routeName));

      final result = await _auth.retrieveAccessCode(
        registrationId: event.registrationId,
        emailAddress: event.emailAddress,
        phoneNumber: event.phoneNumber,
        action: event.action,
      );

      emit(AccessCodeRetrieved(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(RetrieveAccessCodeError(result: error, routeName: event.routeName)),
      );
    }
  }
}
