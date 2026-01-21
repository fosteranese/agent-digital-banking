part of 'biometric_bloc.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object> get props => [];
}

class BiometricInitial extends BiometricState {}

//
// retrieve biometric settings

class RetrievingBiometricSettings extends BiometricState {
  const RetrievingBiometricSettings();

  @override
  List<Object> get props => [];
}

class BiometricSettingsRetrieved extends BiometricState {
  const BiometricSettingsRetrieved({
    required this.login,
    required this.autoLogin,
    required this.transaction,
    required this.autoTransaction,
  });

  final bool login;
  final bool autoLogin;
  final bool transaction;
  final bool autoTransaction;

  @override
  List<Object> get props => [login, autoLogin, transaction, autoTransaction];
}

class RetrievedBiometricSettingsError extends BiometricState {
  const RetrievedBiometricSettingsError(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}

//
// change biometric login status

class ChangingBiometricLoginStatus extends BiometricState {}

class BiometricLoginStatusChanged extends BiometricState {
  const BiometricLoginStatusChanged(this.enabled);

  final bool enabled;

  @override
  List<Object> get props => [enabled];
}

class ChangeBiometricLoginStatusError extends BiometricState {
  const ChangeBiometricLoginStatusError(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}

//
// change auto biometric login status

class ChangingAutoBiometricLoginStatus extends BiometricState {}

class AutoBiometricLoginStatusChanged extends BiometricState {
  const AutoBiometricLoginStatusChanged(this.enabled);

  final bool enabled;

  @override
  List<Object> get props => [enabled];
}

class ChangeAutoBiometricLoginStatusError extends BiometricState {
  const ChangeAutoBiometricLoginStatusError(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}
