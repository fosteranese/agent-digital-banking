import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/data/models/login/verify_id_response.dart';
import 'package:agent_digital_banking/data/models/payee/payees_response.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/schedule/schedules.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/router/auth.router.dart';
import 'package:agent_digital_banking/ui/pages/app_error.page.dart';
import 'package:agent_digital_banking/ui/pages/forget_password/request_password_reset.page.dart';
import 'package:agent_digital_banking/ui/pages/forget_password/reset_password.page.dart';
import 'package:agent_digital_banking/ui/pages/forget_password/verify_password_reset.page.dart';
import 'package:agent_digital_banking/ui/pages/forgot_secret_answer/request_secret_answer.page.dart';
import 'package:agent_digital_banking/ui/pages/intro.page.dart';
import 'package:agent_digital_banking/ui/pages/login/existing_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/new_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/otp_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/secret_answer_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/set_secret_answer_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/verify_id.page.dart';
import 'package:agent_digital_banking/ui/pages/more/profile.page.dart';
import 'package:agent_digital_banking/ui/pages/more/security_settings.page.dart';
import 'package:agent_digital_banking/ui/pages/notifications.page.dart';
import 'package:agent_digital_banking/ui/pages/picture_preview.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/actions.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/enquiry_flow.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/ui/pages/receipt.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient_details.page.dart';
import 'package:agent_digital_banking/ui/pages/schedules/schedule_details.page.dart';
import 'package:agent_digital_banking/ui/pages/schedules/schedules.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/ghana_card_verification.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/otp_account_verification.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account_password.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account_pin.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account_secret_question_and_answer.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_customer.page.dart';
import 'package:agent_digital_banking/ui/pages/update.page.dart';
import 'package:agent_digital_banking/ui/pages/welcome.page.dart';

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
            return ActionsPage(action: extra['action'] ?? extra['activity'], amDoing: extra['amDoing'], payment: extra['payment']);
          },
        ),
        GoRoute(path: ProfilePage.routeName, builder: (context, state) => ProfilePage()),
        GoRoute(
          path: QuickActionsPage.routeName,
          builder: (context, state) {
            return QuickActionsPage(amDoing: state.extra != null ? state.extra as AmDoing : AmDoing.transaction);
          },
        ),
        GoRoute(
          path: ProcessFormPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ProcessFormPage(form: extra['form'], amDoing: extra['amDoing'], activity: extra['activity'], payee: extra['payee'], receiptId: extra['receiptId']);
          },
        ),
        GoRoute(
          path: ConfirmationFormPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ConfirmationFormPage(verifyData: extra['verifyData'], formData: extra['formData'], payload: extra['payload'], amDoing: extra['amDoing'], activityType: extra['activityType'], activity: extra['activity']);
          },
        ),
        GoRoute(
          path: SchedulesPage.routeName,
          builder: (context, state) {
            return SchedulesPage(state.extra as ActivityDatum);
          },
        ),
        GoRoute(
          path: ReceiptPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ReceiptPage(request: extra['request'], fblLogo: extra['fblLogo'], imageBaseUrl: extra['imageBaseUrl'], imageDirectory: extra['imageDirectory']);
          },
        ),
        GoRoute(path: PayeeDetailsPage.routeName, builder: (context, state) => PayeeDetailsPage(state.extra as Payees)),
        GoRoute(path: SecuritySettingsPage.routeName, builder: (context, state) => SecuritySettingsPage()),
        GoRoute(
          path: EnquiryFlowPage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return EnquiryFlowPage(form: extra['form'], enquiry: extra['enquiry']);
          },
        ),
        GoRoute(path: PushNotificationsPage.routeName, builder: (context, state) => PushNotificationsPage()),
        GoRoute(path: ScheduleDetailsPage.routeName, builder: (context, state) => ScheduleDetailsPage(state.extra as Schedules)),
      ],
    ),
    GoRoute(path: WelcomePage.routeName, builder: (context, state) => const WelcomePage()),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),

    GoRoute(path: ExistingDeviceLoginPage.routeName, builder: (context, state) => ExistingDeviceLoginPage(state.extra as bool)),
    GoRoute(path: AppErrorPage.routeName, builder: (context, state) => AppErrorPage(state.extra as Response<dynamic>)),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),
    GoRoute(path: IntroPage.routeName, builder: (context, state) => const IntroPage()),
    GoRoute(path: NewDeviceLoginPage.routeName, builder: (context, state) => const NewDeviceLoginPage()),
    GoRoute(path: SetupAccountPage.routeName, builder: (context, state) => const SetupAccountPage()),
    GoRoute(path: RequestPasswordResetPage.routeName, builder: (context, state) => const RequestPasswordResetPage()),
    GoRoute(path: SecretAnswerLoginPage.routeName, builder: (context, state) => const SecretAnswerLoginPage()),
    GoRoute(path: VerifyIdPage.routeName, builder: (context, state) => VerifyIdPage()),
    GoRoute(path: RequestSecretAnswerPage.routeName, builder: (context, state) => RequestSecretAnswerPage()),
    GoRoute(path: OtpLoginPage.routeName, builder: (context, state) => OtpLoginPage()),
    GoRoute(path: SetSecretAnswerLoginPage.routeName, builder: (context, state) => SetSecretAnswerLoginPage(state.extra as VerifyIdResponse)),
    GoRoute(path: SetupCustomerPage.routeName, builder: (context, state) => SetupCustomerPage()),
    GoRoute(path: GhanaCardVerificationPage.routeName, builder: (context, state) => GhanaCardVerificationPage()),
    GoRoute(
      path: PicturePreviewPage.routeName,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PicturePreviewPage(image: extra['image'], onSuccess: extra['onSuccess'], title: extra['title'], height: extra['height'], width: extra['width']);
      },
    ),
    GoRoute(path: OtpAccountVerificationPage.routeName, builder: (context, state) => OtpAccountVerificationPage()),
    GoRoute(path: SetupAccountPasswordPage.routeName, builder: (context, state) => SetupAccountPasswordPage()),
    GoRoute(
      path: SetupAccountSecretQuestionAndAnswerPage.routeName,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return SetupAccountSecretQuestionAndAnswerPage(password: extra['password'], isLoginBioEnabled: extra['isLoginBioEnabled']);
      },
    ),
    GoRoute(
      path: SetupAccountPinPage.routeName,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return SetupAccountPinPage(password: extra['password'], question: extra['question'], answer: extra['answer'], isLoginBioEnabled: extra['isLoginBioEnabled']);
      },
    ),
    GoRoute(path: VerifyPasswordResetPage.routeName, builder: (context, state) => VerifyPasswordResetPage()),
    GoRoute(path: ResetPasswordPage.routeName, builder: (context, state) => ResetPasswordPage()),
  ],
);
