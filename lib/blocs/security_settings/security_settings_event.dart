part of 'security_settings_bloc.dart';

abstract class SecuritySettingsEvent extends Equatable {
  const SecuritySettingsEvent();

  @override
  List<Object> get props => [];
}

// authenticating pin

class AuthenticatePin extends SecuritySettingsEvent {
  const AuthenticatePin({required this.id, required this.pin});

  final String id;
  final String pin;

  @override
  List<Object> get props => [id, pin];
}

// save biometric setting

class SaveBiometricSetting extends SecuritySettingsEvent {
  const SaveBiometricSetting(this.payload);

  final bool payload;

  @override
  List<Object> get props => [payload];
}

// change pin

class ChangePin extends SecuritySettingsEvent {
  const ChangePin(this.payload);

  final ChangePinRequest payload;

  @override
  List<Object> get props => [payload];
}

// reset pin

class ResetPin extends SecuritySettingsEvent {
  const ResetPin(this.payload);

  final ResetPinRequest payload;

  @override
  List<Object> get props => [payload];
}

// change password

class ChangePassword extends SecuritySettingsEvent {
  const ChangePassword(this.payload);

  final ChangePasswordRequest payload;

  @override
  List<Object> get props => [payload];
}

// change secret answer

class ChangeSecretAnswer extends SecuritySettingsEvent {
  const ChangeSecretAnswer(this.payload);

  final ChangeSecretAnswerRequest payload;

  @override
  List<Object> get props => [payload];
}
