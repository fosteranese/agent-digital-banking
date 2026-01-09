import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/theme.util.dart';
import 'form/button.dart';

enum MessageType {
  success,
  error,
  failed,
  warning,
  info,
  tooltip,
  custom,
  content,
  actions,
  loading,
}

class MyAlertMessenger extends StatefulWidget {
  const MyAlertMessenger({
    super.key,
    required this.message,
    this.title = '',
    this.messageType = MessageType.info,
    this.close,
    this.content,
    this.actions,
    this.image,
  });

  final String title;
  final String message;
  final MessageType messageType;
  final void Function()? close;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? image;

  @override
  State<MyAlertMessenger> createState() => _MyAlertMessengerState();
}

class _MyAlertMessengerState extends State<MyAlertMessenger> {
  EdgeInsetsGeometry? get _setPadding {
    switch (widget.messageType) {
      case MessageType.content:
      case MessageType.actions:
        return const EdgeInsets.only(top: 5);
      case MessageType.tooltip:
        return EdgeInsets.zero;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.messageType == MessageType.tooltip
          ? const Color(0xff54534A)
          : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: _shape,
      titlePadding: _setPadding,
      contentPadding: _contentPadding,
      title: Builder(
        builder: (context) {
          switch (widget.messageType) {
            case MessageType.success:
              return Column(
                children: [
                  widget.image ??
                      SvgPicture.asset(
                        'assets/img/success.svg',
                        width: 80,
                        theme: const SvgTheme(currentColor: Colors.red),
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'Successful',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            case MessageType.warning:
              return Column(
                children: [
                  SvgPicture.asset(
                    'assets/img/warning.svg',
                    width: 100,
                    theme: const SvgTheme(currentColor: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Warning',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            case MessageType.failed:
              return Column(
                children: [
                  const SizedBox(height: 10),
                  // SvgPicture.asset('assets/img/error.svg'),
                  const SizedBox(height: 5),
                  Text(
                    'Oh No!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            case MessageType.error:
              return Column(
                children: [
                  const SizedBox(height: 10),
                  // SvgPicture.asset('assets/img/error.svg'),
                  const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      'Oh No!',
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            case MessageType.info:
              return Text(
                'Info',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              );
            case MessageType.tooltip:
              return const SizedBox();
            case MessageType.content:
            case MessageType.actions:
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: widget.close ?? () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              );
            default:
              return const SizedBox();
          }
        },
      ),
      content: Builder(
        builder: (context) {
          switch (widget.messageType) {
            case MessageType.content:
            case MessageType.custom:
              return widget.content ?? const SizedBox();
            case MessageType.loading:
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CupertinoActivityIndicator(radius: 20, color: ThemeUtil.primaryColor),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    textAlign: TextAlign.center,
                    widget.message,
                    style: PrimaryTextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 50),
                ],
              );
            case MessageType.tooltip:
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      textAlign: TextAlign.left,
                      style: PrimaryTextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: widget.close ?? () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Text(
                          'Close',
                          textAlign: TextAlign.end,
                          style: PrimaryTextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case MessageType.error:
            case MessageType.failed:
              return Text(
                widget.message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(
                  color: const Color(0xff242424),
                  fontWeight: FontWeight.w400,
                ),
              );
            default:
              return Text(
                widget.message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              );
          }
        },
      ),
      actions: _action,
    );
  }

  EdgeInsets? get _contentPadding {
    switch (widget.messageType) {
      case MessageType.tooltip:
        return const EdgeInsets.all(20);
      default:
        return null;
    }
  }

  RoundedRectangleBorder get _shape {
    switch (widget.messageType) {
      case MessageType.tooltip:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
      default:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));
    }
  }

  List<Widget>? get _action {
    switch (widget.messageType) {
      case MessageType.actions:
        return widget.actions ?? [];
      case MessageType.content:
      case MessageType.custom:
      case MessageType.loading:
      case MessageType.tooltip:
        return null;

      case MessageType.success:
        return [
          SizedBox(
            width: double.maxFinite,
            child: FormButton(
              text: 'Got it',
              onPressed: widget.close ?? () => Navigator.of(context).pop(),
            ),
          ),
        ];

      default:
        return [
          Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: FormButton(
                  text: 'Try again',
                  onPressed: widget.close ?? () => Navigator.of(context).pop(),
                ),
              ),
              // const SizedBox(height: 20),
              // Text(
              //   'Contact Support',
              //   style: PrimaryTextStyle(
              //     fontWeight: FontWeight.w600,
              //     fontSize: 14,
              //   ),
              // )
            ],
          ),
        ];
    }
  }
}
