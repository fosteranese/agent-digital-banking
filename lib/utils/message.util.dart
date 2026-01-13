import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

final class MessageUtil {
  static void displayLoading(BuildContext context, {String? title, String? message}) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      barrierDismissible: false,
      requestFocus: true,
      barrierColor: Colors.white70,
      builder: (context) => ZoomIn(
        child: FadeIn(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(radius: 20, color: ThemeUtil.primaryColor),
                  if (message != null) const SizedBox(height: 5),
                  if (message != null)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading(BuildContext context) {
    context.pop();
  }

  static void displayErrorDialog(
    BuildContext context, {
    String? title,
    String? message,
    String okButtonText = 'Ok',
    void Function()? onOkPressed,
    Widget? customButton,
  }) {
    showDialog(
      barrierColor: Colors.black.withAlpha((0.8 * 224).toInt()),
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => ZoomIn(
        child: FadeIn(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 55),
                  const SizedBox(height: 10),
                  if (title != null)
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  if (message != null) const SizedBox(height: 5),
                  if (message != null)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  FormButton(
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                      if (onOkPressed != null) {
                        onOkPressed();
                      }
                    },
                    text: okButtonText,
                  ),
                  if (customButton != null) customButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void displaySuccessDialog(
    BuildContext context, {
    String? title,
    String? message,
    void Function()? onOk,
  }) {
    showDialog(
      barrierColor: Colors.black.withAlpha((0.8 * 224).toInt()),
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => ZoomIn(
        child: FadeIn(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 42.5,
                    backgroundColor: Color(0xffCEFFCE),
                    child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                  ),
                  const SizedBox(height: 10),
                  if (title != null)
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  if (message != null) const SizedBox(height: 10),
                  if (message != null)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  FormButton(
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                      if (onOk != null) {
                        onOk();
                      }
                    },
                    text: 'OK',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void displaySuccessFullDialog(
    BuildContext context, {
    String? title,
    String? message,
    void Function()? onOk,
  }) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      fullscreenDialog: true,
      builder: (context) => ZoomIn(
        child: Dialog(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: .zero),
          insetPadding: .zero,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                const Spacer(flex: 2),
                SvgPicture.asset('assets/img/done.svg'),
                const SizedBox(height: 30),
                Text(
                  textAlign: TextAlign.center,
                  title ?? 'Successful',
                  style: PrimaryTextStyle(fontWeight: .w600, fontSize: 20, color: ThemeUtil.black),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  message ?? 'Your action was completed successfully.',
                  style: PrimaryTextStyle(fontWeight: .w400, fontSize: 16, color: ThemeUtil.grey),
                ),
                const Spacer(flex: 3),
                FormButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                    if (onOk != null) {
                      onOk();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void displayActionDialog(
    BuildContext context, {
    String? title,
    String? message,
    required void Function() onConfirm,
    Color onConfirmButtonColor = ThemeUtil.secondaryColor,
    Color onConfirmButtonTextColor = ThemeUtil.secondaryColor,
    Widget? icon,
    String onConfirmText = 'Confirm',
  }) {
    showDialog(
      barrierColor: Colors.black.withAlpha((0.8 * 224).toInt()),
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => ZoomIn(
        child: FadeIn(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon ?? SvgPicture.asset('assets/img/cylinder.svg', width: 50),
                  const SizedBox(height: 10),
                  if (title != null)
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(
                        // color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  if (message != null) const SizedBox(height: 5),
                  if (message != null)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FormOutlineButton(
                          height: 50,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FormButton(
                          backgroundColor: onConfirmButtonColor,
                          foregroundColor: onConfirmButtonTextColor,
                          height: 50,
                          onPressed: () {
                            Navigator.pop(context);
                            onConfirm();
                          },
                          text: onConfirmText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
