part of 'loader_bloc.dart';

abstract class LoaderState extends Equatable {
  const LoaderState();

  @override
  List<Object?> get props => [];
}

class InitialLoader extends LoaderState {}

class StopLoading extends LoaderState {}

class LoadingLoader extends LoaderState {
  final String message;

  const LoadingLoader(this.message);

  @override
  List<Object> get props => [message];
}

class SuccessfulLoader extends LoaderState {
  final String message;

  const SuccessfulLoader(this.message);

  @override
  List<Object> get props => [message];
}

class SuccessfulWithOptionsLoader extends LoaderState {
  final String title;
  final String? message;
  final void Function() onClose;

  const SuccessfulWithOptionsLoader({required this.title, this.message, required this.onClose});

  @override
  List<Object?> get props => [title, message, onClose];
}

class SuccessfulGeneralFlowOptionsLoader extends LoaderState {
  final String title;
  final Response<RequestResponse> result;
  final void Function() onClose;
  final void Function()? onSaveBeneficiary;
  final void Function()? onScheduleTransaction;
  final void Function()? onShowReceipt;

  const SuccessfulGeneralFlowOptionsLoader({
    required this.title,
    required this.result,
    required this.onClose,
    this.onSaveBeneficiary,
    this.onScheduleTransaction,
    this.onShowReceipt,
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

class SuccessfulPayeeAddedOptionsLoader extends LoaderState {
  final String title;
  final Response result;
  final void Function() onClose;
  final void Function()? onShowDetails;

  const SuccessfulPayeeAddedOptionsLoader({
    required this.title,
    required this.result,
    required this.onClose,
    this.onShowDetails,
  });

  @override
  List<Object?> get props => [title, result, onClose, onShowDetails];
}

class SuccessfulBulkPaymentLoader extends LoaderState {
  final String title;
  final Response result;
  final void Function() onClose;
  final void Function()? onGotoHistory;

  const SuccessfulBulkPaymentLoader({
    required this.title,
    required this.result,
    required this.onClose,
    this.onGotoHistory,
  });

  @override
  List<Object?> get props => [title, result, onClose, onGotoHistory];
}

class FailedLoader extends LoaderState {
  final String message;

  const FailedLoader(this.message);

  @override
  List<Object> get props => [message];
}

class FailedWithOptionsLoader extends LoaderState {
  final String title;
  final String? message;
  final void Function() onClose;

  const FailedWithOptionsLoader({required this.title, this.message, required this.onClose});

  @override
  List<Object?> get props => [title, message, onClose];
}

class InfoLoader extends LoaderState {
  final String message;

  const InfoLoader(this.message);

  @override
  List<Object> get props => [message];
}
