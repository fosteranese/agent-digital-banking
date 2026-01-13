part of 'loader_bloc.dart';

abstract class LoaderEvent extends Equatable {
  const LoaderEvent();

  @override
  List<Object?> get props => [];
}

class InitiateLoaderEvent extends LoaderEvent {
  const InitiateLoaderEvent();

  @override
  List<Object> get props => [];
}

class StopLoadingEvent extends LoaderEvent {
  const StopLoadingEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends LoaderEvent {
  final String message;

  const LoadingEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SucceededEvent extends LoaderEvent {
  final String message;

  const SucceededEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SucceededWithOptionsEvent extends LoaderEvent {
  final String title;
  final String? message;
  final void Function() onClose;

  const SucceededWithOptionsEvent({required this.title, this.message, required this.onClose});

  @override
  List<Object?> get props => [title, message, onClose];
}

class SuccessGeneralFlowOptionsEvent extends LoaderEvent {
  final String title;
  final Response<RequestResponse> result;
  final void Function() onClose;
  final void Function()? onSaveBeneficiary;
  final void Function()? onScheduleTransaction;
  final void Function()? onShowReceipt;

  const SuccessGeneralFlowOptionsEvent({
    required this.title,
    required this.result,
    required this.onClose,
    required this.onSaveBeneficiary,
    required this.onScheduleTransaction,
    required this.onShowReceipt,
  });

  @override
  List<Object?> get props => [
    title,
    result,
    onClose,
    onSaveBeneficiary,
    onScheduleTransaction,
    onShowReceipt,
  ];
}

class SuccessPayeeAddedOptionsEvent extends LoaderEvent {
  final String title;
  final Response result;
  final void Function() onClose;
  final void Function()? onShowDetails;

  const SuccessPayeeAddedOptionsEvent({
    required this.title,
    required this.result,
    required this.onClose,
    required this.onShowDetails,
  });

  @override
  List<Object?> get props => [title, result, onClose, onShowDetails];
}

class SuccessBulkPaymentEvent extends LoaderEvent {
  final String title;
  final Response result;
  final void Function() onClose;
  final void Function()? onGotoHistory;

  const SuccessBulkPaymentEvent({
    required this.title,
    required this.result,
    required this.onClose,
    required this.onGotoHistory,
  });

  @override
  List<Object?> get props => [title, result, onClose, onGotoHistory];
}

class FailedEvent extends LoaderEvent {
  final String message;

  const FailedEvent(this.message);

  @override
  List<Object> get props => [message];
}

class FailedWithOptionsEvent extends LoaderEvent {
  final String title;
  final String? message;
  final void Function() onClose;

  const FailedWithOptionsEvent({required this.title, this.message, required this.onClose});

  @override
  List<Object?> get props => [title, message, onClose];
}

class InfoEvent extends LoaderEvent {
  final String message;

  const InfoEvent(this.message);

  @override
  List<Object> get props => [message];
}

class StopEvent extends LoaderEvent {
  const StopEvent();

  @override
  List<Object> get props => [];
}

class CompleteStopLoadingEvent extends LoaderEvent {
  const CompleteStopLoadingEvent();

  @override
  List<Object> get props => [];
}
