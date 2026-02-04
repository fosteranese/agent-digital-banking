part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class NewCustomerSignUp extends AuthEvent {
  const NewCustomerSignUp(this.payload);

  final NonCustomerSignUpRequest payload;

  @override
  List<Object> get props => [payload];
}

class NewCustomerReSignUp extends AuthEvent {
  const NewCustomerReSignUp(this.payload);

  final NonCustomerSignUpRequest payload;

  @override
  List<Object> get props => [payload];
}

class VerifyOtp extends AuthEvent {
  const VerifyOtp({required this.payload, required this.isNewCustomer});

  final OtpVerificationRequest payload;
  final bool isNewCustomer;

  @override
  List<Object> get props => [payload, isNewCustomer];
}

class CustomerSignUp extends AuthEvent {
  const CustomerSignUp(this.payload);

  final CustomerSignUpRequest payload;

  @override
  List<Object> get props => [payload];
}

class VerifyCustomer extends AuthEvent {
  const VerifyCustomer({required this.payload, required this.data});

  final OtpVerificationRequest payload;
  final VerificationResponse data;

  @override
  List<Object> get props => [payload, data];
}

class CompleteSignUp extends AuthEvent {
  const CompleteSignUp(this.payload);

  final CompleteSignUpRequest payload;

  @override
  List<Object> get props => [payload];
}

class CompleteCustomerSignUp extends AuthEvent {
  const CompleteCustomerSignUp(this.payload);

  final CompleteSignUpRequest payload;

  @override
  List<Object> get props => [payload];
}

class RetrieveProfilePicture extends AuthEvent {
  const RetrieveProfilePicture({this.tryCount = 0});

  final int tryCount;

  @override
  List<Object> get props => [tryCount];
}

// verify ghana card

class VerifyGhanaCard extends AuthEvent {
  const VerifyGhanaCard({required this.registrationId, required this.picture, required this.code});

  final String registrationId;
  final String picture;
  final String code;

  @override
  List<Object> get props => [registrationId, picture, code];
}

class ReVerifyGhanaCard extends AuthEvent {
  const ReVerifyGhanaCard(this.registrationId);

  final String registrationId;

  @override
  List<Object> get props => [registrationId];
}
// verify ghana card

class VerifyPicture extends AuthEvent {
  const VerifyPicture({
    required this.registrationId,
    this.picture = '',
    this.isNewCustomer = false,
    this.code = '',
  });

  final String registrationId;
  final String picture;
  final String code;
  final bool isNewCustomer;

  @override
  List<Object> get props => [registrationId, picture, code, isNewCustomer];
}

class ReVerifyPicture extends AuthEvent {
  const ReVerifyPicture({required this.registrationId, this.isNewCustomer = false});

  final String registrationId;
  final bool isNewCustomer;

  @override
  List<Object> get props => [registrationId, isNewCustomer];
}

class SignInVerifyGhanaCard extends AuthEvent {
  const SignInVerifyGhanaCard({required this.registrationId, this.picture = '', this.code = ''});

  final String registrationId;
  final String picture;
  final String code;

  @override
  List<Object> get props => [registrationId, picture, code];
}

class SignInReVerifyGhanaCard extends AuthEvent {
  const SignInReVerifyGhanaCard({required this.registrationId});

  final String registrationId;

  @override
  List<Object> get props => [registrationId];
}

// forgot password

class InitiateForgotPassword extends AuthEvent {
  const InitiateForgotPassword(this.payload);

  final ForgotPasswordRequest payload;

  @override
  List<Object> get props => [payload];
}

class ReInitiateForgotPassword extends AuthEvent {
  const ReInitiateForgotPassword(this.payload);

  final ForgotPasswordRequest payload;

  @override
  List<Object> get props => [payload];
}

class VerifyForgotPassword extends AuthEvent {
  const VerifyForgotPassword(this.payload);

  final OtpVerificationRequest payload;

  @override
  List<Object> get props => [payload];
}

class ResetPassword extends AuthEvent {
  const ResetPassword(this.payload);

  final ResetPasswordRequest payload;

  @override
  List<Object> get props => [payload];
}

// forgot secret answer

class RetrieveSecretAnswer extends AuthEvent {
  const RetrieveSecretAnswer(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

// login

class InitiateLogin extends AuthEvent {
  const InitiateLogin(this.payload);

  final InitiateLoginRequest payload;

  @override
  List<Object> get props => [payload];
}

class ReInitiateLogin extends AuthEvent {
  const ReInitiateLogin({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class VerifyLogin extends AuthEvent {
  const VerifyLogin(this.payload);

  final VerifyLoginRequest payload;

  @override
  List<Object> get props => [payload];
}

class ResetSecurityAnswerLogin extends AuthEvent {
  const ResetSecurityAnswerLogin({
    required this.registrationId,
    required this.question,
    required this.answer,
  });

  final String registrationId;
  final String answer;
  final String question;

  @override
  List<Object> get props => [registrationId, question, answer];
}

class SetSecurityAnswerLogin extends AuthEvent {
  const SetSecurityAnswerLogin({
    required this.registrationId,
    required this.question,
    required this.answer,
  });

  final String registrationId;
  final String answer;
  final String question;

  @override
  List<Object> get props => [registrationId, question, answer];
}

class ReVerifyLogin extends AuthEvent {
  const ReVerifyLogin(this.payload);

  final VerifyLoginRequest payload;

  @override
  List<Object> get props => [payload];
}

class CompleteLogin extends AuthEvent {
  const CompleteLogin(this.payload);

  final OtpVerificationRequest payload;

  @override
  List<Object> get props => [payload];
}

// unlock screen
class UnLockScreen extends AuthEvent {
  const UnLockScreen(this.payload);

  final UnLockScreenRequest payload;

  @override
  List<Object> get props => [payload];
}

// refresh user data
class RefreshUserData extends AuthEvent {
  const RefreshUserData();

  @override
  List<Object> get props => [];
}

// logout
class Logout extends AuthEvent {
  const Logout();

  @override
  List<Object> get props => [];
}

class ForceUpdate extends AuthEvent {
  const ForceUpdate(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}

// save pin
class SavePin extends AuthEvent {
  const SavePin(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

// retrieve pin
class RetrievePin extends AuthEvent {
  const RetrievePin();

  @override
  List<Object> get props => [];
}

class ChangeProfilePicture extends AuthEvent {
  const ChangeProfilePicture({required this.routeName, required this.picture});

  final String routeName;
  final String picture;

  @override
  List<Object> get props => [routeName, picture];
}
