import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/request_response.dart';
import '../../data/models/response.modal.dart';

part 'loader_event.dart';
part 'loader_state.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(InitialLoader()) {
    on(_onLoading);
    on(_onStopLoading);
    on(_onSuccess);
    on(_onSuccessWithOptions);
    on(_onSuccessfulGeneralFlowOptions);
    on(_onSuccessfulPayeeAddedOptions);
    on(_onSuccessfulBulkPaymentOptions);
    on(_onFailed);
    on(_onFailedWithOptions);
    on(_onInfo);
  }

  void _onLoading(
    LoadingEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(LoadingLoader(event.message));
  }

  void _onStopLoading(
    StopLoadingEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(StopLoading());
  }

  void _onSuccess(
    SucceededEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(SuccessfulLoader(event.message));
  }

  void _onSuccessWithOptions(
    SucceededWithOptionsEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(
      SuccessfulWithOptionsLoader(
        title: event.title,
        message: event.message,
        onClose: event.onClose,
      ),
    );
  }

  void _onSuccessfulGeneralFlowOptions(
    SuccessGeneralFlowOptionsEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(
      SuccessfulGeneralFlowOptionsLoader(
        title: event.title,
        result: event.result,
        onClose: event.onClose,
        onSaveBeneficiary: event.onSaveBeneficiary,
        onScheduleTransaction: event.onScheduleTransaction,
        onShowReceipt: event.onShowReceipt,
      ),
    );
  }

  void _onSuccessfulPayeeAddedOptions(
    SuccessPayeeAddedOptionsEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(
      SuccessfulPayeeAddedOptionsLoader(
        title: event.title,
        result: event.result,
        onClose: event.onClose,
        onShowDetails: event.onShowDetails,
      ),
    );
  }

  void _onSuccessfulBulkPaymentOptions(
    SuccessBulkPaymentEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(
      SuccessfulBulkPaymentLoader(
        title: event.title,
        result: event.result,
        onClose: event.onClose,
        onGotoHistory: event.onGotoHistory,
      ),
    );
  }

  void _onFailed(
    FailedEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(FailedLoader(event.message));
  }

  void _onFailedWithOptions(
    FailedWithOptionsEvent event,
    Emitter<LoaderState> emit,
  ) {
    emit(
      FailedWithOptionsLoader(
        title: event.title,
        message: event.message,
        onClose: event.onClose,
      ),
    );
  }

  void _onInfo(InfoEvent event, Emitter<LoaderState> emit) {
    emit(InfoLoader(event.message));
  }
}
