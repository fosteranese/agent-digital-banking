import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../ui/components/messenger.dart';

class Messenger {
  Messenger();

  String message = '';
  Widget? image;
  String title = '';
  List<Widget> actions = [];
  Widget? content;
  MessageType messageType = MessageType.info;

  Future _display({void Function()? onClose}) {
    return showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: messageType == MessageType.tooltip
          ? Colors.transparent
          : const Color(0xE0000000),
      useSafeArea: false,
      builder: (BuildContext context) {
        return MyAlertMessenger(
          title: title,
          message: message,
          actions: actions,
          content: content,
          image: image,
          close: () {
            close();
            if (onClose != null) {
              onClose();
            }
          },
          messageType: messageType,
        );
      },
    );
  }

  void successAlert(
    String message, {
    void Function()? onClose,
    String? title,
    Widget? icon,
  }) {
    title ??= 'Successful';
    image = icon;
    this.message = message;
    messageType = MessageType.success;

    _display(onClose: onClose);
  }

  void errorAlert(
    String message, {
    void Function()? onClose,
  }) {
    title = 'Error';
    this.message = message;
    messageType = MessageType.error;

    _display(onClose: onClose);
  }

  void infoAlert(
    String message, {
    void Function()? onClose,
  }) {
    title = 'Info';
    this.message = message;
    messageType = MessageType.info;

    _display(onClose: onClose);
  }

  void tooltip(String message, {void Function()? onClose}) {
    title = 'Tip';
    this.message = message;
    messageType = MessageType.tooltip;

    _display(onClose: onClose);
  }

  void warningAlert(
    String message, {
    void Function()? onClose,
  }) {
    title = 'Warning';
    this.message = message;
    messageType = MessageType.warning;

    _display(onClose: onClose);
  }

  void failedAlert(
    String message, {
    void Function()? onClose,
  }) {
    title = 'Failed';
    this.message = message;
    messageType = MessageType.failed;

    _display(onClose: onClose);
  }

  void contentAlert(
    Widget content, {
    void Function()? onClose,
  }) {
    this.content = content;

    messageType = MessageType.content;

    _display(onClose: onClose);
  }

  void actionAlert(
    List<Widget> actions, {
    void Function()? onClose,
  }) {
    this.actions = actions;
    messageType = MessageType.actions;

    _display(onClose: onClose);
  }

  void customAlert(
    Widget content, {
    void Function()? onClose,
  }) {
    this.content = content;

    messageType = MessageType.custom;

    _display(onClose: onClose);
  }

  void loadingAlert({String message = 'Loading'}) {
    this.message = message;
    messageType = MessageType.loading;

    _display();
  }

  void close() {
    MyApp.navigatorKey.currentContext!.pop();
  }
}
