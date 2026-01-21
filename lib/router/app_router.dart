import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/data/models/login/verify_id_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/router/auth.router.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification_upload.dart';
import 'package:my_sage_agent/ui/pages/app_error.page.dart';
import 'package:my_sage_agent/ui/pages/forget_password/request_password_reset.page.dart';
import 'package:my_sage_agent/ui/pages/forget_password/reset_password.page.dart';
import 'package:my_sage_agent/ui/pages/forget_password/verify_password_reset.page.dart';
import 'package:my_sage_agent/ui/pages/forgot_secret_answer/request_secret_answer.page.dart';
import 'package:my_sage_agent/ui/pages/intro.page.dart';
import 'package:my_sage_agent/ui/pages/login/existing_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/otp_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/set_secret_answer_login.page.dart';
import 'package:my_sage_agent/ui/pages/more/commissions.page.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/ui/pages/more/security_settings.page.dart';
import 'package:my_sage_agent/ui/pages/notifications.page.dart';
import 'package:my_sage_agent/ui/pages/picture_preview.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/actions.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/enquiry_flow.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/receipt.page.dart';
import 'package:my_sage_agent/ui/pages/register_client.page.dart';
import 'package:my_sage_agent/ui/pages/update.page.dart';
import 'package:my_sage_agent/ui/pages/welcome.page.dart';

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: MyApp.navigatorKey,
  errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found'))),
  redirect: (context, state) {
    // You can plug in auth check here
    // Example: if user is not logged in, redirect to /login
    // final isLoggedIn = checkAuth();
    // if (!isLoggedIn && state.sub_loc != '/login') return '/login';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
      routes: [
        authRouter,
        GoRoute(
          path: UpdatePage.routeName,
          builder: (context, state) {
            return UpdatePage(state.extra as Response);
          },
        ),
        GoRoute(
          path: ActionsPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ActionsPage(
              action: extra['action'] ?? extra['activity'],
              amDoing: extra['amDoing'],
              payment: extra['payment'],
            );
          },
        ),
        GoRoute(path: ProfilePage.routeName, builder: (context, state) => ProfilePage()),
        GoRoute(
          path: QuickActionsPage.routeName,
          builder: (context, state) {
            return QuickActionsPage(
              amDoing: state.extra != null ? state.extra as AmDoing : AmDoing.transaction,
            );
          },
        ),
        GoRoute(
          path: ProcessFormPage.routeName,
          builder: (context, state) {
            final page = state.extra as ProcessFormPage;
            return page;
          },
        ),
        GoRoute(
          path: ConfirmationFormPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ConfirmationFormPage(
              verifyData: extra['verifyData'],
              formData: extra['formData'],
              payload: extra['payload'],
              amDoing: extra['amDoing'],
              activityType: extra['activityType'],
              activity: extra['activity'],
            );
          },
        ),
        GoRoute(
          path: ReceiptPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ReceiptPage(
              request: extra['request'],
              fblLogo: extra['fblLogo'],
              imageBaseUrl: extra['imageBaseUrl'],
              imageDirectory: extra['imageDirectory'],
            );
          },
        ),
        GoRoute(
          path: SecuritySettingsPage.routeName,
          builder: (context, state) => SecuritySettingsPage(),
        ),
        GoRoute(path: CommissionsPage.routeName, builder: (context, state) => CommissionsPage()),
        GoRoute(
          path: EnquiryFlowPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return EnquiryFlowPage(form: extra['form'], enquiry: extra['enquiry']);
          },
        ),
        GoRoute(
          path: PushNotificationsPage.routeName,
          builder: (context, state) => PushNotificationsPage(),
        ),
      ],
    ),
    GoRoute(path: WelcomePage.routeName, builder: (context, state) => const WelcomePage()),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),

    GoRoute(
      path: ExistingDeviceLoginPage.routeName,
      builder: (context, state) => ExistingDeviceLoginPage(state.extra as bool),
    ),
    GoRoute(
      path: AppErrorPage.routeName,
      builder: (context, state) => AppErrorPage(state.extra as Response<dynamic>),
    ),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),
    GoRoute(
      path: NewDeviceLoginPage.routeName,
      builder: (context, state) => const NewDeviceLoginPage(),
    ),
    GoRoute(
      path: RequestPasswordResetPage.routeName,
      builder: (context, state) => const RequestPasswordResetPage(),
    ),
    GoRoute(
      path: RequestSecretAnswerPage.routeName,
      builder: (context, state) => RequestSecretAnswerPage(),
    ),
    GoRoute(path: OtpLoginPage.routeName, builder: (context, state) => OtpLoginPage()),
    GoRoute(
      path: SetSecretAnswerLoginPage.routeName,
      builder: (context, state) => SetSecretAnswerLoginPage(state.extra as VerifyIdResponse),
    ),
    GoRoute(
      path: PicturePreviewPage.routeName,
      builder: (context, state) {
        final page = state.extra as PicturePreviewPage;
        return page;
      },
    ),
    GoRoute(
      path: GhanaCardVerification.routeName,
      builder: (context, state) {
        final page = state.extra as GhanaCardVerification;
        return page;
      },
    ),
    GoRoute(
      path: GhanaCardVerificationUpload.routeName,
      builder: (context, state) {
        final page = state.extra as GhanaCardVerificationUpload;
        return page;
      },
    ),
    GoRoute(
      path: VerifyPasswordResetPage.routeName,
      builder: (context, state) => VerifyPasswordResetPage(),
    ),
    GoRoute(path: ResetPasswordPage.routeName, builder: (context, state) => ResetPasswordPage()),
    GoRoute(
      path: RegisterClientPage.routeName,
      builder: (context, state) {
        return const RegisterClientPage();
      },
    ),
  ],
);
