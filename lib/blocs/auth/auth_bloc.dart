import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/data/models/complete_signup.request.dart';
import 'package:my_sage_agent/data/models/customer_sign_up/customer_sign_up.request.dart';
import 'package:my_sage_agent/data/models/forgot_password/forgot_password.request.dart';
import 'package:my_sage_agent/data/models/forgot_password/forgot_password.response.dart';
import 'package:my_sage_agent/data/models/forgot_password/reset_password.request.dart';
import 'package:my_sage_agent/data/models/login/complete_login.request.dart';
import 'package:my_sage_agent/data/models/login/initiate_login.request.dart';
import 'package:my_sage_agent/data/models/login/verify_id_response.dart';
import 'package:my_sage_agent/data/models/non_customer_sign_up/non_customer_sign_up.request.dart';
import 'package:my_sage_agent/data/models/otp_verification.request.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/unlock_screen.request.dart';
import 'package:my_sage_agent/data/models/user_response/user_response.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/data/models/verify_ghana_card_response.dart';
import 'package:my_sage_agent/data/repository/auth.repo.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/response.util.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on(_onVerifyOtp);

    on(_onVerifyCustomer);

    // verify ghana card
    on(_onVerifyGhanaCard);
    on(_onReVerifyGhanaCard);
    on(_onVerifyPicture);
    on(_onReVerifyPicture);
    on(_onSignInVerifyGhanaCard);
    on(_onSignInReVerifyGhanaCard);

    // forgot password
    on(_onInitiateForgetPassword);
    on(_onReInitiateForgetPassword);
    on(_onVerifyForgetPassword);
    on(_onResetPassword);

    // forgot secret answer
    on(_onRetrieveSecretAnswer);

    // login
    on(_onInitiateLogin);
    on(_onReInitiateLogin);
    on(_onVerifyLogin);
    on(_onReVerifyLogin);
    on(_onSetSecurityAnswerLogin);
    on(_onResetSecurityAnswerLogin);
    on(_onCompleteLogin);
    on(_onRetrieveProfilePicture);

    // unlock screen
    on(_onUnlockScreen);

    // refresh dashboard
    on(_onRefreshUserData);

    // logout
    on(_onLogout);

    // force update
    on(_onForceUpdate);

    // pin
    on(_onSavePin);
    on(_onRetrievePin);

    // change profile picture
    on(_onChangeProfilePicture);
  }

  final _authRepo = AuthRepo();
  VerificationResponse? signIn;
  String phoneNumber = '';
  String password = '';
  String pin = '';
  String requestId = '';
  String picture = '';
  String code = '';

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingOtp());
      final result = !event.isNewCustomer
          ? await _authRepo.verifyNewCustomerOtp(event.payload)
          : await _authRepo.verifyNoNNewCustomerOtp(event.payload);

      requestId = result;
      emit(OtpVerified(result));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyOtpError(error)));
    }
  }

  Future<void> _onVerifyCustomer(VerifyCustomer event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingCustomerOtp());
      final result = await _authRepo.verifyNewCustomerOtp(event.payload);

      requestId = result;
      emit(CustomerOtpVerified(requestId: result, data: event.data));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyCustomerOtpError(error)));
    }
  }

  Future<void> _onRetrieveProfilePicture(
    RetrieveProfilePicture event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await _authRepo.getProfilePicture();

      AppUtil.currentUser = AppUtil.currentUser.copyWith(profilePicture: result);
      _authRepo.saveJustLoggedUser(AppUtil.currentUser);

      emit(LoggedIn(AppUtil.currentUser));
    } catch (error) {
      if (event.tryCount > 5) return;

      // await Future.delayed(const Duration(seconds: 5));
      // await _onRetrieveProfilePicture(RetrieveProfilePicture(tryCount: event.tryCount + 1), emit);
    }
  }

  // verify ghana card
  Future<void> _onVerifyGhanaCard(VerifyGhanaCard event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingGhanaCard());
      picture = event.picture;
      code = event.code;
      final result = await _authRepo.verifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(GhanaCardVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyGhanaCardError(error)));
    }
  }

  Future<void> _onReVerifyGhanaCard(ReVerifyGhanaCard event, Emitter<AuthState> emit) async {
    try {
      emit(ReVerifyingGhanaCard());
      final result = await _authRepo.verifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(GhanaCardReVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReVerifyGhanaCardError(error)));
    }
  }

  // verify ghana card
  Future<void> _onVerifyPicture(VerifyPicture event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingGhanaCard());
      picture = event.picture;
      code = event.code;
      final result = !event.isNewCustomer
          ? await _authRepo.verifyPicture(
              registrationId: event.registrationId,
              picture: picture,
              code: code,
            )
          : await _authRepo.verifyPicture(
              registrationId: event.registrationId,
              picture: picture,
              code: code,
            );

      emit(GhanaCardVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyGhanaCardError(error)));
    }
  }

  Future<void> _onReVerifyPicture(ReVerifyPicture event, Emitter<AuthState> emit) async {
    try {
      emit(ReVerifyingGhanaCard());
      final result = await _authRepo.verifyPicture(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(GhanaCardReVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReVerifyGhanaCardError(error)));
    }
  }

  // verify ghana card
  Future<void> _onSignInVerifyGhanaCard(
    SignInVerifyGhanaCard event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(VerifyingGhanaCard());
      picture = event.picture;
      code = event.code;
      final result = await _authRepo.signUpVerifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(GhanaCardVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyGhanaCardError(error)));
    }
  }

  Future<void> _onSignInReVerifyGhanaCard(
    SignInReVerifyGhanaCard event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(ReVerifyingGhanaCard());
      final result = await _authRepo.signUpVerifyGhanaCard(
        registrationId: event.registrationId,
        picture: picture,
        code: code,
      );

      emit(GhanaCardReVerified(data: result, resendPayload: event.registrationId));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReVerifyGhanaCardError(error)));
    }
  }

  Future<void> _onInitiateForgetPassword(
    InitiateForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(InitiatingForgotPassword());
      final result = await _authRepo.forgotPassword(event.payload);

      emit(ForgotPasswordInitiated(data: result, resendPassword: event.payload));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(InitiateForgotPasswordError(error)));
    }
  }

  Future<void> _onReInitiateForgetPassword(
    ReInitiateForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(ReInitiatingForgotPassword());
      final result = await _authRepo.forgotPassword(event.payload);

      emit(ForgotPasswordReInitiated(data: result, resendPassword: event.payload));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReInitiateForgotPasswordError(error)));
    }
  }

  Future<void> _onVerifyForgetPassword(VerifyForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingForgotPassword());
      final result = await _authRepo.verifyForgotPassword(event.payload);

      emit(ForgotPasswordVerified(result));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyForgotPasswordError(error)));
    }
  }

  Future<void> _onResetPassword(ResetPassword event, Emitter<AuthState> emit) async {
    try {
      emit(ResettingPassword());
      final result = await _authRepo.resetPassword(event.payload);

      emit(PasswordResetCompleted(result));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ResetPasswordError(error)));
    }
  }

  // forgot secret answer
  Future<void> _onRetrieveSecretAnswer(RetrieveSecretAnswer event, Emitter<AuthState> emit) async {
    try {
      emit(RetrievingSecretAnswer());
      final result = await _authRepo.forgotSecretAnswer(event.phoneNumber);

      emit(SecretAnswerRetrieved(result));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(RetrieveSecretAnswerError(error)));
    }
  }

  // login
  Future<void> _onInitiateLogin(InitiateLogin event, Emitter<AuthState> emit) async {
    try {
      emit(InitiatingLogin());
      final result = await _authRepo.initiateLogin(event.payload);
      phoneNumber = event.payload.phoneNumber ?? '';
      password = event.payload.password ?? '';

      signIn = result;

      emit(LoginInitiated(result));
    } catch (error) {
      if (error is Response) {
        if (error.code == '2000') {
          phoneNumber = event.payload.phoneNumber ?? '';
          password = event.payload.password ?? '';
          emit(
            InitiateLoginError(
              Response(
                code: error.code,
                status: error.status,
                message: error.message,
                data: VerifyIdResponse.fromMap(error.data),
              ),
            ),
          );
          return;
        }
      }

      ResponseUtil.handleException(error, (error) => emit(InitiateLoginError(error)));
    }
  }

  // login
  Future<void> _onReInitiateLogin(ReInitiateLogin event, Emitter<AuthState> emit) async {
    try {
      emit(ReInitiatingLogin());
      final result = await _authRepo.initiateLogin(
        InitiateLoginRequest(phoneNumber: phoneNumber, password: password),
      );

      signIn = result;
      emit(ReLoginInitiated(result));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReInitiateLoginError(error)));
    }
  }

  Future<void> _onVerifyLogin(VerifyLogin event, Emitter<AuthState> emit) async {
    try {
      emit(VerifyingLogin());
      final result = await _authRepo.verifyLogin(event.payload);

      emit(LoginVerified(data: result, resendPayload: event.payload));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(VerifyLoginError(error)));
    }
  }

  Future<void> _onReVerifyLogin(ReVerifyLogin event, Emitter<AuthState> emit) async {
    try {
      emit(ReVerifyingLogin());
      final result = await _authRepo.verifyLogin(event.payload);

      emit(LoginReVerified(data: result, resendPayload: event.payload));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ReVerifyLoginError(error)));
    }
  }

  Future<void> _onSetSecurityAnswerLogin(
    SetSecurityAnswerLogin event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(SettingSecurityAnswerLogin());
      final result = await _authRepo.resetSecurityAnswer(
        registrationId: event.registrationId,
        question: event.question,
        answer: event.answer,
      );

      emit(
        SecurityAnswerLoginSet(
          data: result,
          resendPayload: {
            "registrationId": event.registrationId,
            "question": event.question,
            "answer": event.answer,
          },
        ),
      );
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(SetSecurityAnswerLoginError(error)));
    }
  }

  Future<void> _onResetSecurityAnswerLogin(
    ResetSecurityAnswerLogin event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(ResettingSecurityAnswerLogin());
      final result = await _authRepo.resetSecurityAnswer(
        registrationId: event.registrationId,
        question: event.question,
        answer: event.answer,
      );

      emit(
        SecurityAnswerLoginReset(
          data: result,
          resendPayload: {
            "registrationId": event.registrationId,
            "question": event.question,
            "answer": event.answer,
          },
        ),
      );
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ResetSecurityAnswerLoginError(error)));
    }
  }

  Future<void> _onCompleteLogin(CompleteLogin event, Emitter<AuthState> emit) async {
    try {
      emit(CompletingLogin());
      final result = await _authRepo.completeLogin(event.payload);
      await _authRepo.clearDbForNewUser();

      AppUtil.currentUser = result;
      _authRepo.saveLoggedUser(user: result, password: password);
      password = '';

      emit(LoginCompleted(result));
      emit(LoggedIn(result));

      await _onRetrieveProfilePicture(const RetrieveProfilePicture(), emit);
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(CompleteLoginError(error)));
    }
  }

  // unlock screen
  Future<void> _onUnlockScreen(UnLockScreen event, Emitter<AuthState> emit) async {
    try {
      emit(UnLockingScreen());

      var pwd = event.payload.password;
      if (!(event.payload.isPassword ?? false)) {
        pwd = (await _authRepo.getCurrentUserPassword()) ?? '';
      }

      final payload = event.payload.copyWith(password: pwd);
      final result = await _authRepo.unLockScreen(payload);
      _authRepo.saveLoggedUser(user: result, password: payload.password!);

      AppUtil.currentUser = result;

      emit(ScreenUnLocked(result));
      emit(LoggedIn(result));

      await _onRetrieveProfilePicture(const RetrieveProfilePicture(), emit);
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(UnlockScreenError(error)));
    }
  }

  // refresh user data
  Future<void> _onRefreshUserData(RefreshUserData event, Emitter<AuthState> emit) async {
    try {
      emit(const RefreshingUserData());
      final result = await _authRepo.refreshUserData();
      AppUtil.currentUser = result;

      emit(LoggedIn(result));

      await _onRetrieveProfilePicture(const RetrieveProfilePicture(), emit);
    } catch (ex) {
      emit(const RefreshUserDataFailed());
    }
  }

  // logout
  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(const LoggedOut());
  }

  // force update
  Future<void> _onForceUpdate(ForceUpdate event, Emitter<AuthState> emit) async {
    emit(const ForcingUpdate());
    emit(UpdateForced(event.result));
  }

  // save pin
  Future<void> _onSavePin(SavePin event, Emitter<AuthState> emit) async {
    pin = event.pin;
    _authRepo.saveCurrentUserPin(event.pin);
  }

  // retrieve pin
  Future<void> _onRetrievePin(RetrievePin event, Emitter<AuthState> emit) async {
    pin = await _authRepo.getCurrentUserPin() ?? '';
  }

  // refresh user data
  Future<void> _onChangeProfilePicture(ChangeProfilePicture event, Emitter<AuthState> emit) async {
    try {
      emit(ChangingProfilePicture(event.routeName));
      final result = await _authRepo.changeProfilePicture(event.picture);
      AppUtil.currentUser = AppUtil.currentUser.copyWith(profilePicture: result);

      emit(ProfilePictureChanged(event.routeName));
      _authRepo.saveJustLoggedUser(AppUtil.currentUser);

      emit(LoggedIn(AppUtil.currentUser));
    } catch (error) {
      ResponseUtil.handleException(
        error,
        (error) => emit(ProfilePictureError(routeName: event.routeName, result: error)),
      );
    }
  }
}
