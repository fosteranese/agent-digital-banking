import 'package:agent_digital_banking/data/models/complete_signup.request.dart';

import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/customer_sign_up/customer_sign_up.request.dart';
import '../models/forgot_password/forgot_password.request.dart';
import '../models/forgot_password/forgot_password.response.dart';
import '../models/forgot_password/reset_password.request.dart';
import '../models/initialization_response.dart';
import '../models/login/complete_login.request.dart';
import '../models/login/initiate_login.request.dart';
import '../models/non_customer_sign_up/non_customer_sign_up.request.dart';
import '../models/otp_verification.request.dart';
import '../models/response.modal.dart';
import '../models/unlock_screen.request.dart';
import '../models/user_response/user_response.dart';
import '../models/verification.response.dart';
import '../models/verify_ghana_card_response.dart';
import '../remote/main.remote.dart';
import 'app.repo.dart';

class AuthRepo {
  final _db = Database();
  final _fbl = MainRemote();
  final _app = AppRepo();

  Future<InitializationResponse> initiateDevice() async {
    final response = await _fbl.post(path: 'UserAccess/initialization', body: {});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return InitializationResponse.fromJson(response.data);
  }

  Future<VerificationResponse> signUpNewCustomer(NonCustomerSignUpRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/initiateAccountOpening', body: {"phoneNumber": payload.phoneNumber, "email": payload.email, "cardNumber": payload.cardNumber, "branch": payload.branch, "accountType": payload.accountType, "residentialAddress": payload.residentialAddress, "city": payload.city});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerificationResponse.fromMap(response.data);
  }

  Future<VerificationResponse> signUpCustomer(CustomerSignUpRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/signUpCustomer', body: {"accountNumber": payload.accountNumber, "cardNumber": payload.ghanaCardNumber});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerificationResponse.fromMap(response.data);
  }

  Future<String> verifyNewCustomerOtp(OtpVerificationRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/validateSignUpOtp', body: {"otpId": payload.otpId, "otpValue": payload.otpValue});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data["requestId"];
  }

  Future<String> verifyNoNNewCustomerOtp(OtpVerificationRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/CompleteAccountOpeningGhana', body: {"otpId": payload.otpId, "otpValue": payload.otpValue});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data["requestId"];
  }

  Future<UserResponse> completeNewCustomerSignup(CompleteSignUpRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/CompleteCustomerSignUp', body: {"registrationId": payload.registrationId, "secretQuestion": payload.question, "secretAnswer": payload.answer, "password": payload.password, "pin": payload.pin});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return UserResponse.fromMap(response.data);
  }

  Future<UserResponse> completeCustomerSignup(CompleteSignUpRequest payload) async {
    final response = await _fbl.post(path: 'UserAccess/CompleteCustomerSignUp', body: {"registrationId": payload.registrationId, "password": payload.password, "secretQuestion": payload.question, "secretAnswer": payload.answer, "pin": payload.pin});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return UserResponse.fromMap(response.data);
  }

  Future<String> getProfilePicture() async {
    final response = await _fbl.post(path: 'MyAccount/myProfilePicture', body: {}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data as String;
  }

  Future<VerifyGhanaCardResponse> verifyGhanaCard({required String registrationId, required String picture, required String code}) async {
    final response = await _fbl.post(path: 'UserAccess/ConfirmGhanaCard', body: {"registrationId": registrationId, "picture": picture, "code": code});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerifyGhanaCardResponse.fromMap(response.data);
  }

  Future<VerifyGhanaCardResponse> verifyPicture({required String registrationId, required String picture, required String code}) async {
    final response = await _fbl.post(path: 'UserAccess/ConfirmGhanaCard', body: {"registrationId": registrationId, "picture": picture, "code": code});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerifyGhanaCardResponse.fromMap(response.data);
  }

  Future<VerifyGhanaCardResponse> signUpVerifyGhanaCard({required String registrationId, required String picture, required String code}) async {
    final response = await _fbl.post(path: 'SignIn/VerifyGhanaCard', body: {"registrationId": registrationId, "picture": picture, "code": code});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerifyGhanaCardResponse.fromMap(response.data);
  }

  Future<VerifyGhanaCardResponse> verifyAccountOpeningGhanaCard({required String registrationId, required String picture}) async {
    final response = await _fbl.post(path: 'UserAccess/verifyAccountOpeningGhanaCard', body: {"registrationId": registrationId, "picture": picture});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerifyGhanaCardResponse.fromMap(response.data);
  }

  // forgot password
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest payload) async {
    final response = await _fbl.post(path: 'Forgot/initiateForgotPassword', body: {"phoneNumber": payload.phoneNumber, "securityAnswer": payload.answer});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return ForgotPasswordResponse.fromMap(response.data);
  }

  Future<String> verifyForgotPassword(OtpVerificationRequest payload) async {
    final response = await _fbl.post(path: 'Forgot/validateOtp', body: {"otpId": payload.otpId, "otpValue": payload.otpValue});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data['requestId'];
  }

  Future<String> resetPassword(ResetPasswordRequest payload) async {
    final response = await _fbl.post(path: 'Forgot/setNewPassword', body: {"requestId": payload.requestId, "password": payload.password});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.message;
  }

  // forgot secret answer
  Future<String> forgotSecretAnswer(String phoneNumber) async {
    final response = await _fbl.post(path: 'Forgot/initiateForgotSecurityAnswer', body: {"phoneNumber": phoneNumber});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.message;
  }

  // login

  Future<Response> initiateLogin(InitiateLoginRequest payload) async {
    final response = await _fbl.post(path: 'SignIn/newDevice', body: {"phoneNumber": payload.phoneNumber, "password": payload.password});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response;
  }

  Future<VerificationResponse> verifyLogin(VerifyLoginRequest payload) async {
    final response = await _fbl.post(path: 'SignIn/verifySecurityAnswer', body: {"requestId": payload.requestId, "securityAnswer": payload.securityAnswer});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerificationResponse.fromMap(response.data);
  }

  Future<VerificationResponse> resetSecurityAnswer({required String registrationId, required String question, required String answer}) async {
    final response = await _fbl.post(path: 'Forgot/setNewSecurityQuestion', body: {"registrationId": registrationId, "secretQuestion": question, "secretAnswer": answer});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return VerificationResponse.fromMap(response.data);
  }

  Future<UserResponse> completeLogin(OtpVerificationRequest payload) async {
    final response = await _fbl.post(path: 'SignIn/verifyOtp', body: {"otpId": payload.otpId, "otpValue": payload.otpValue});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return UserResponse.fromMap(response.data);
  }

  Future<UserResponse> unLockScreen(UnLockScreenRequest payload) async {
    final response = await _fbl.post(path: 'SignIn/existingDevice', body: {"isPassword": payload.isPassword, "password": payload.password}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return UserResponse.fromMap(response.data);
  }

  Future<UserResponse> refreshUserData() async {
    final response = await _fbl.post(path: 'MyAccount/refreshDasboard', body: {}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return UserResponse.fromMap(response.data);
  }

  Future<void> saveLoggedUser({required UserResponse user, required String password}) async {
    await _db.add(key: 'current-user', payload: user.toMap());
    await _db.add(key: 'current-user-password', payload: {'password': password});
  }

  Future<void> saveJustLoggedUser(UserResponse user) async {
    await _db.add(key: 'current-user', payload: user.toMap());
  }

  Future<String?> getCurrentUserPassword() async {
    final data = await _db.read('current-user-password');

    if (data != null) {
      return data['password'].toString();
    }

    return null;
  }

  Future<void> saveCurrentUserPin(String pin) async {
    await _db.add(key: 'current-user-pin', payload: {'pin': pin});
  }

  Future<String?> getCurrentUserPin() async {
    final data = await _db.read('current-user-pin');

    if (data != null) {
      final pin = data['pin'].toString();
      return pin;
    }

    return null;
  }

  Future<void> clearDbForNewUser() async {
    final initialData = await _app.getInitialData();
    await _db.deleteAll();

    if (initialData != null) {
      await _app.saveInitialData(initialData);
    }
  }

  Future<Response> authenticatePin(String pin) async {
    final response = await _fbl.post(path: 'MyAccount/verifyPin', body: {'pin': pin}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return Response(code: response.code, status: response.status, message: response.message);
  }

  Future<Response> resendOtp(String formId) async {
    final response = await _fbl.post(path: 'UserAccess/resendFormOtp', body: {'formId': formId}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return Response(code: response.code, status: response.status, message: response.message);
  }

  Future<Response> retrieveAccessCode({required String registrationId, required String phoneNumber, required String emailAddress, required String action}) async {
    final response = await _fbl.post(path: 'Forgot/initiateForgotAccessCode', body: {'registrationId': registrationId, 'phoneNumber': phoneNumber, 'emailAddress': emailAddress, 'requestType': action}, isAuthenticated: false);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return Response(code: response.code, status: response.status, message: response.message);
  }

  Future<String> changeProfilePicture(String picture) async {
    final response = await _fbl.post(path: 'MyAccount/updateProfilePicture', body: {'picture': picture}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data as String;
  }
}
