part of 'biometric_bloc.dart';

abstract class BiometricEvent extends Equatable {
  const BiometricEvent();

  @override
  List<Object> get props => [];
}

class RetrieveBiometricSettings extends BiometricEvent {
  const RetrieveBiometricSettings();

  @override
  List<Object> get props => [];
}

class BiometricLoginStatusChange extends BiometricEvent {
  const BiometricLoginStatusChange(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

class ResetBiometricSettings extends BiometricEvent {
  const ResetBiometricSettings();

  @override
  List<Object> get props => [];
}

class AutoBiometricLoginStatusChange extends BiometricEvent {
  const AutoBiometricLoginStatusChange(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

class BiometricTransactionStatusChange extends BiometricEvent {
  const BiometricTransactionStatusChange(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

class AutoBiometricTransactionStatusChange extends BiometricEvent {
  const AutoBiometricTransactionStatusChange(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}
