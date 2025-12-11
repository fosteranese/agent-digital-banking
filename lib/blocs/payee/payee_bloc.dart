import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agent_digital_banking/main.dart';

import '../../data/models/payee/payees_response.dart';
import '../../data/models/process_request.model.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/payee.repo.dart';
import '../../utils/response.util.dart';

part 'payee_event.dart';
part 'payee_state.dart';

class PayeeBloc extends Bloc<PayeeEvent, PayeeState> {
  PayeeBloc() : super(PayeeInitial()) {
    // get payees
    on(_onLoadPayees);
    on(_onRetrieveFormPayees);
    on(_onFilterPayees);
    on(_onLoadAllPayees);

    // add payee
    on(_onAddPayee);

    // delete payee
    on(_onDeletePayee);

    // send payee now
    on(_onSendPayeeNow);
  }

  final _repo = PayeeRepo();

  void Function() replayGetAllPayees = () {};

  Response<PayeesResponse> payees = const Response(code: '', status: '', message: '', data: null);

  Map<String, Response<PayeesResponse>> payeesMap = {};
  Map<String, Response<List<Payees>>> formPayeesMap = {};

  //
  // get all payees

  Future<void> _onLoadPayees(LoadPayees event, Emitter<PayeeState> emit) async {
    replayGetAllPayees = () {
      MyApp.navigatorKey.currentContext!.read<PayeeBloc>().add(event);
    };
    Response<PayeesResponse>? stored;
    try {
      if (payees.data?.payees?.isNotEmpty ?? false) {
        stored = payees;
        emit(PayeesLoaded(result: payees));

        if (event.showSilentLoading) {
          emit(const SilentLoadingPayees());
        }
      } else {
        emit(const LoadingPayees());

        stored = await _repo.getStoredPayees();
        if (stored?.data?.payees?.isNotEmpty ?? false) {
          payees = stored!;
          emit(PayeesLoaded(result: stored));

          if (event.showSilentLoading) {
            emit(const SilentLoadingPayees());
          }
        } else if (payees.data?.payees?.isNotEmpty ?? false) {
          emit(PayeesLoaded(result: payees));

          if (event.showSilentLoading) {
            emit(const SilentLoadingPayees());
          }
        }
      }

      final result = await _repo.retrievePayees();
      if (result.data != null) {
        payees = result;
      }

      if (stored?.data?.payees?.isEmpty ?? false) {
        emit(PayeesLoaded(result: payees));
      } else {
        emit(PayeesLoadedSilently(result: payees));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.payees?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(LoadPayeesError(error)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentLoadPayeesError(error)));
      }
    }
  }

  Future<void> _onRetrieveFormPayees(RetrieveFormPayees event, Emitter<PayeeState> emit) async {
    Response<List<Payees>>? stored;
    try {
      if (formPayeesMap[event.formId]?.data?.isNotEmpty ?? false) {
        stored = formPayeesMap[event.formId];
        emit(FormPayeesRetrieved(formId: event.formId, result: stored!));
      } else {
        emit(RetrievingFormPayees(event.formId));

        stored = await _repo.getStoredFormPayees(event.formId);
        if (stored?.data?.isNotEmpty ?? false) {
          formPayeesMap[event.formId] = stored!;
          emit(FormPayeesRetrieved(formId: event.formId, result: stored));
        } else if (payees.data?.payees?.isNotEmpty ?? false) {
          emit(FormPayeesRetrieved(formId: event.formId, result: formPayeesMap[event.formId]!));
        }
      }

      final result = await _repo.retrieveFormPayees(event.formId);
      if (result.data != null) {
        formPayeesMap[event.formId] = result;
      }

      emit(FormPayeesRetrieved(formId: event.formId, result: formPayeesMap[event.formId]!));
    } catch (ex) {
      if (stored == null || (stored.data?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(LoadPayeesError(error)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentLoadPayeesError(error)));
      }
    }
  }

  Future<void> _onFilterPayees(FilterPayees event, Emitter<PayeeState> emit) async {
    replayGetAllPayees = () {
      MyApp.navigatorKey.currentContext!.read<PayeeBloc>().add(event);
    };

    try {
      emit(const LoadingPayees());
      final result = await _repo.filterPayees(event.form);
      emit(PayeesLoaded(result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(LoadPayeesError(error)));
    }
  }

  Future<void> _onLoadAllPayees(LoadAllPayees event, Emitter<PayeeState> emit) async {
    replayGetAllPayees = () {
      MyApp.navigatorKey.currentContext!.read<PayeeBloc>().add(event);
    };

    try {
      emit(const LoadingPayees());
      final result = await _repo.retrievePayees();
      emit(PayeesLoaded(result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(LoadPayeesError(error)));
    }
  }

  //
  // add Payee

  Future<void> _onAddPayee(AddPayee event, Emitter<PayeeState> emit) async {
    try {
      emit(AddingPayee(event.routeName));
      final stored = await _repo.addPayee(payment: event.payment, payload: event.payload);
      emit(PayeeAdded(result: stored, routeName: event.routeName));

      await _onLoadPayees(const LoadPayees(false), emit);
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) {
        emit(AddPayeeError(result: error, routeName: event.routeName));
        emit(PayeesLoaded(result: payees));
      });
    }
  }

  //
  // delete Payee

  Future<void> _onDeletePayee(DeletePayee event, Emitter<PayeeState> emit) async {
    try {
      emit(DeletingPayee(event.routeName));
      final stored = await _repo.deletePayee(event.payee.payeeId ?? '');
      emit(PayeeDeleted(result: stored, routeName: event.routeName));

      await _onLoadPayees(const LoadPayees(false), emit);
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) {
        emit(DeletePayeeError(result: error, routeName: event.routeName));
        emit(PayeesLoaded(result: payees));
      });
    }
  }

  //
  // send Payee now

  Future<void> _onSendPayeeNow(SendPayeeNow event, Emitter<PayeeState> emit) async {
    try {
      emit(SendingPayeeNow(event.routeName));
      final stored = await _repo.sendPayeeNow(payeeId: event.payee.payeeId ?? '', pin: event.pin);
      emit(PayeeSentNow(result: stored, routeName: event.routeName));

      emit(PayeesLoaded(result: payees));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) {
        emit(SendPayeeNowError(result: error, routeName: event.routeName));
        emit(PayeesLoaded(result: payees));
      });
    }
  }
}
