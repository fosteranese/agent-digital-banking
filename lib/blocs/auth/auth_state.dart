part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

// new customer signup
class SubmittingNewCustomerDetails extends AuthState {}

class NewCustomerDetailsSubmitted extends AuthState {
  const NewCustomerDetailsSubmitted({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final NonCustomerSignUpRequest resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class SubmitNewCustomerDetailsError extends AuthState {
  const SubmitNewCustomerDetailsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ReSubmittingNewCustomerDetails extends AuthState {}

class NewCustomerDetailsReSubmitted extends AuthState {
  const NewCustomerDetailsReSubmitted({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final NonCustomerSignUpRequest resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class ReSubmitNewCustomerDetailsError extends AuthState {
  const ReSubmitNewCustomerDetailsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class VerifyingOtp extends AuthState {}

class OtpVerified extends AuthState {
  const OtpVerified(this.requestId);

  final String requestId;

  @override
  List<Object> get props => [requestId];
}

class VerifyOtpError extends AuthState {
  const VerifyOtpError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// existing customer signup

class SubmittingCustomerDetails extends AuthState {}

class CustomerDetailsSubmitted extends AuthState {
  const CustomerDetailsSubmitted(this.data);

  final dynamic data;
  // final CustomerVerificationResponse data;

  @override
  List<Object> get props => [data];
}

class SubmitCustomerDetailsError extends AuthState {
  const SubmitCustomerDetailsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class VerifyingCustomerOtp extends AuthState {}

class CustomerOtpVerified extends AuthState {
  const CustomerOtpVerified({required this.requestId, required this.data});

  final String requestId;
  final VerificationResponse data;

  @override
  List<Object> get props => [requestId, data];
}

class VerifyCustomerOtpError extends AuthState {
  const VerifyCustomerOtpError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class CompletingSignUp extends AuthState {}

class SignUpCompleted extends AuthState {
  const SignUpCompleted(this.user);

  final UserResponse user;

  @override
  List<Object> get props => [user];
}

class CompleteSignUpError extends AuthState {
  const CompleteSignUpError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class LoggedIn extends AuthState {
  const LoggedIn(this.user);

  final UserResponse user;

  @override
  List<Object> get props => [user];
}

class RefreshUserDataFailed extends AuthState {
  const RefreshUserDataFailed();

  @override
  List<Object> get props => [];
}

class RefreshingUserData extends AuthState {
  const RefreshingUserData();

  @override
  List<Object> get props => [];
}

// verify ghana card

class VerifyingGhanaCard extends AuthState {}

class GhanaCardVerified extends AuthState {
  const GhanaCardVerified({required this.data, required this.resendPayload});

  final VerifyGhanaCardResponse data;
  final String resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class VerifyGhanaCardError extends AuthState {
  const VerifyGhanaCardError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ReVerifyingGhanaCard extends AuthState {}

class GhanaCardReVerified extends AuthState {
  const GhanaCardReVerified({required this.data, required this.resendPayload});

  final VerifyGhanaCardResponse data;
  final String resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class ReVerifyGhanaCardError extends AuthState {
  const ReVerifyGhanaCardError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// Forgot Password

class InitiatingForgotPassword extends AuthState {}

class ForgotPasswordInitiated extends AuthState {
  const ForgotPasswordInitiated({required this.data, required this.resendPassword});

  final ForgotPasswordResponse data;
  final ForgotPasswordRequest resendPassword;

  @override
  List<Object> get props => [data, resendPassword];
}

class InitiateForgotPasswordError extends AuthState {
  const InitiateForgotPasswordError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ReInitiatingForgotPassword extends AuthState {}

class ForgotPasswordReInitiated extends AuthState {
  const ForgotPasswordReInitiated({required this.data, required this.resendPassword});

  final ForgotPasswordResponse data;
  final ForgotPasswordRequest resendPassword;

  @override
  List<Object> get props => [data, resendPassword];
}

class ReInitiateForgotPasswordError extends AuthState {
  const ReInitiateForgotPasswordError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class VerifyingForgotPassword extends AuthState {}

class ForgotPasswordVerified extends AuthState {
  const ForgotPasswordVerified(this.requestId);

  final String requestId;

  @override
  List<Object> get props => [requestId];
}

class VerifyForgotPasswordError extends AuthState {
  const VerifyForgotPasswordError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ResettingPassword extends AuthState {}

class PasswordResetCompleted extends AuthState {
  const PasswordResetCompleted(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ResetPasswordError extends AuthState {
  const ResetPasswordError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// Forgot secret answer

class RetrievingSecretAnswer extends AuthState {}

class SecretAnswerRetrieved extends AuthState {
  const SecretAnswerRetrieved(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class RetrieveSecretAnswerError extends AuthState {
  const RetrieveSecretAnswerError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// login user

class InitiatingLogin extends AuthState {}

class VerifyId extends AuthState {
  const VerifyId(this.result);

  final Response<VerifyIdResponse> result;

  @override
  List<Object> get props => [result];
}

class LoginInitiated extends AuthState {
  const LoginInitiated(this.otpData);

  final VerificationResponse otpData;

  @override
  List<Object> get props => [otpData];
}

class InitiateLoginError extends AuthState {
  const InitiateLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ReInitiatingLogin extends AuthState {}

class ReLoginInitiated extends AuthState {
  const ReLoginInitiated(this.requestId);

  final VerificationResponse requestId;

  @override
  List<Object> get props => [requestId];
}

class ReInitiateLoginError extends AuthState {
  const ReInitiateLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class VerifyingLogin extends AuthState {}

class LoginVerified extends AuthState {
  const LoginVerified({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final VerifyLoginRequest resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class VerifyLoginError extends AuthState {
  const VerifyLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ReVerifyingLogin extends AuthState {}

class LoginReVerified extends AuthState {
  const LoginReVerified({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final VerifyLoginRequest resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class ReVerifyLoginError extends AuthState {
  const ReVerifyLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class SettingSecurityAnswerLogin extends AuthState {}

class SecurityAnswerLoginSet extends AuthState {
  const SecurityAnswerLoginSet({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final Map<String, String> resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class SetSecurityAnswerLoginError extends AuthState {
  const SetSecurityAnswerLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class ResettingSecurityAnswerLogin extends AuthState {}

class SecurityAnswerLoginReset extends AuthState {
  const SecurityAnswerLoginReset({required this.data, required this.resendPayload});

  final VerificationResponse data;
  final Map<String, String> resendPayload;

  @override
  List<Object> get props => [data, resendPayload];
}

class ResetSecurityAnswerLoginError extends AuthState {
  const ResetSecurityAnswerLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class CompletingLogin extends AuthState {}

class LoginCompleted extends AuthState {
  const LoginCompleted(this.user);

  final UserResponse user;

  @override
  List<Object> get props => [user];
}

class CompleteLoginError extends AuthState {
  const CompleteLoginError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// unlock screen user

class UnLockingScreen extends AuthState {}

class ScreenUnLocked extends AuthState {
  const ScreenUnLocked(this.user);

  final UserResponse user;

  @override
  List<Object> get props => [user];
}

class UnlockScreenError extends AuthState {
  const UnlockScreenError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// logout

class LoggingOut extends AuthState {}

class LoggedOut extends AuthState {
  const LoggedOut();
}

// force update

class ForcingUpdate extends AuthState {
  const ForcingUpdate();
}

class UpdateForced extends AuthState {
  const UpdateForced(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}

class ChangingProfilePicture extends AuthState {
  const ChangingProfilePicture(this.routeName);

  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class ProfilePictureChanged extends AuthState {
  const ProfilePictureChanged(this.routeName);

  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class ProfilePictureError extends AuthState {
  const ProfilePictureError({required this.routeName, required this.result});

  final String routeName;
  final Response<dynamic> result;

  @override
  List<Object> get props => [routeName, result];
}
