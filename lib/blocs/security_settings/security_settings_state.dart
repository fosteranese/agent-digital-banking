part of 'security_settings_bloc.dart';

abstract class SecuritySettingsState extends Equatable {
  const SecuritySettingsState();

  @override
  List<Object> get props => [];
}

class SecuritySettingsInitial
    extends SecuritySettingsState {}

// authenticate pin

class AuthenticatingPin extends SecuritySettingsState {
  const AuthenticatingPin(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class PinAuthenticated extends SecuritySettingsState {
  const PinAuthenticated({
    required this.id,
    required this.pin,
    required this.result,
  });

  final String id;
  final String pin;
  final Response<dynamic> result;

  @override
  List<Object> get props => [id, pin, result];
}

class PinAuthenticationError extends SecuritySettingsState {
  const PinAuthenticationError({
    required this.id,
    required this.result,
  });

  final String id;
  final Response<dynamic> result;

  @override
  List<Object> get props => [id, result];
}

// biometric login

class SavingBiometricSetting
    extends SecuritySettingsState {}

class BiometricSettingSaved extends SecuritySettingsState {
  const BiometricSettingSaved({
    required this.enable,
    required this.message,
  });

  final bool enable;
  final String message;
}

class SaveBiometricSettingError
    extends SecuritySettingsState {
  const SaveBiometricSettingError(this.result);

  final Response<dynamic> result;
}

// change PIN

class ChangingPin extends SecuritySettingsState {}

class PinChanged extends SecuritySettingsState {
  const PinChanged(this.message);

  final String message;
}

class ChangePinError extends SecuritySettingsState {
  const ChangePinError(this.result);

  final Response<dynamic> result;
}

// forgot PIN

class ResettingPin extends SecuritySettingsState {}

class PinReset extends SecuritySettingsState {
  const PinReset(this.message);

  final String message;
}

class ResetPinError extends SecuritySettingsState {
  const ResetPinError(this.result);

  final Response<dynamic> result;
}

// change Password

class ChangingPassword extends SecuritySettingsState {}

class PasswordChanged extends SecuritySettingsState {
  const PasswordChanged(this.message);

  final String message;
}

class ChangePasswordError extends SecuritySettingsState {
  const ChangePasswordError(this.result);

  final Response<dynamic> result;
}

// change secret answer

class ChangingSecretAnswer extends SecuritySettingsState {}

class SecretAnswerChanged extends SecuritySettingsState {
  const SecretAnswerChanged(this.message);

  final String message;
}

class ChangeSecretAnswerError
    extends SecuritySettingsState {
  const ChangeSecretAnswerError(this.result);

  final Response<dynamic> result;
}
