import 'package:flutter/material.dart';

import '../blocs/loader/loader_bloc.dart';
import '../data/models/request_response.dart';
import '../data/models/response.modal.dart';
import '../main.dart';
import '../ui/components/loader/loader.dart';
import '../ui/components/messenger.dart';

class Loader {
  Loader();

  String message = '';
  MessageType messageType = MessageType.info;
  final loaderBloc = LoaderBloc();
  bool _displayed = false;

  Future _display() {
    return showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierColor: Colors.black.withAlpha(179), // const Color(0xE0ffffff).withOpacity(0.2),
      useSafeArea: false,
      builder: (BuildContext context) {
        return MyLoader(bloc: loaderBloc);
      },
    );
  }

  void start(String message) {
    this.message = message;
    loaderBloc.add(LoadingEvent(message));
    _display();
    _displayed = true;
  }

  void success(String message) {
    this.message = message;
    loaderBloc.add(SucceededEvent(message));
    _displayed = false;
  }

  Future<void> successWithOptions({
    required String title,
    String? message,
    required void Function() onClose,
  }) async {
    if (!_displayed) {
      _display();
      loaderBloc.add(LoadingEvent(message ?? ''));
      await Future.delayed(const Duration(milliseconds: 100));
    }
    this.message = title;
    loaderBloc.add(SucceededWithOptionsEvent(title: title, message: message, onClose: onClose));
    _displayed = false;
  }

  Future<void> successTransaction({
    required String title,
    required Response<RequestResponse> result,
    required void Function() onClose,
    void Function()? onSaveBeneficiary,
    void Function()? onScheduleTransaction,
    Future<void> Function()? onShowReceipt,
  }) async {
    if (!_displayed) {
      _display();
      loaderBloc.add(LoadingEvent(message));
      await Future.delayed(const Duration(milliseconds: 100));
    }

    message = title;
    loaderBloc.add(
      SuccessGeneralFlowOptionsEvent(
        title: title,
        result: result,
        onClose: onClose,
        onSaveBeneficiary: onSaveBeneficiary,
        onScheduleTransaction: onScheduleTransaction,
        onShowReceipt: onShowReceipt,
      ),
    );
    _displayed = false;
  }

  Future<void> successPayeeAdded({
    required String title,
    required Response result,
    required void Function() onClose,
    void Function()? onShowDetails,
  }) async {
    if (!_displayed) {
      _display();
      loaderBloc.add(LoadingEvent(message));
      await Future.delayed(const Duration(milliseconds: 100));
    }

    message = title;
    loaderBloc.add(
      SuccessPayeeAddedOptionsEvent(
        title: title,
        result: result,
        onClose: onClose,
        onShowDetails: onShowDetails,
      ),
    );
    _displayed = false;
  }

  Future<void> successBulkPayment({
    required String title,
    required Response<dynamic> result,
    required void Function() onClose,
    required void Function() onGotoHistory,
  }) async {
    if (!_displayed) {
      _display();
      loaderBloc.add(LoadingEvent(message));
      await Future.delayed(const Duration(milliseconds: 100));
    }
    message = title;
    loaderBloc.add(
      SuccessBulkPaymentEvent(
        title: title,
        result: result,
        onClose: onClose,
        onGotoHistory: onGotoHistory,
      ),
    );
    _displayed = false;
  }

  void info(String message) {
    this.message = message;
    loaderBloc.add(InfoEvent(message));
    _displayed = false;
  }

  void failed(String message) {
    this.message = message;
    loaderBloc.add(FailedEvent(message));
    _displayed = false;
  }

  Future<void> failedWithOptions({
    required String title,
    String? message,
    required void Function() onClose,
  }) async {
    if (!_displayed) {
      _display();
      loaderBloc.add(LoadingEvent(message ?? ''));
      await Future.delayed(const Duration(milliseconds: 100));
    }
    this.message = title;
    loaderBloc.add(FailedWithOptionsEvent(title: title, message: message, onClose: onClose));
    _displayed = false;
  }

  void stop() {
    loaderBloc.add(const StopLoadingEvent());
    _displayed = false;
    Navigator.pop(MyApp.navigatorKey.currentContext!);
  }
}
