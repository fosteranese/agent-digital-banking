import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response.modal.dart';
import '../../data/models/security_settings/change_password.request.dart';
import '../../data/models/security_settings/change_pin.request.dart';
import '../../data/models/security_settings/change_secret_answer.request.dart';
import '../../data/models/security_settings/reset_pin.request.dart';
import '../../data/repository/auth.repo.dart';
import '../../utils/response.util.dart';

part 'security_settings_event.dart';
part 'security_settings_state.dart';

class SecuritySettingsBloc extends Bloc<SecuritySettingsEvent, SecuritySettingsState> {
  SecuritySettingsBloc() : super(SecuritySettingsInitial()) {
    on(_onAuthenticatePin);
    on(_onSaveBiometricSetting);
    on(_onChangePin);
    on(_onResetPin);
    on(_onChangePassword);
    on(_onChangeSecretAnswer);
  }
  final _repo = AuthRepo();

  late bool enableBiometricLogin;

  Future<void> _onAuthenticatePin(
    AuthenticatePin event,
    Emitter<SecuritySettingsState> emit,
  ) async {
    emit(AuthenticatingPin(event.id));
    try {
      final result = await _repo.authenticatePin(event.pin);
      emit(PinAuthenticated(id: event.id, pin: event.pin, result: result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(PinAuthenticationError(id: event.id, result: error)),
      );
    }
  }

  Future<void> _onSaveBiometricSetting(
    SaveBiometricSetting event,
    Emitter<SecuritySettingsState> emit,
  ) async {
    emit(SavingBiometricSetting());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(
        BiometricSettingSaved(
          enable: event.payload,
          message: event.payload ? "Biometric Login Enabled" : "Biometric Login Disabled",
        ),
      );
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SaveBiometricSettingError(error)));
    }
  }

  Future<void> _onChangePin(ChangePin event, Emitter<SecuritySettingsState> emit) async {
    emit(ChangingPin());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const PinChanged("PIN Changed"));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ChangePinError(error)));
    }
  }

  Future<void> _onResetPin(ResetPin event, Emitter<SecuritySettingsState> emit) async {
    emit(ResettingPin());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const PinReset("PIN Reset"));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ResetPinError(error)));
    }
  }

  Future<void> _onChangePassword(ChangePassword event, Emitter<SecuritySettingsState> emit) async {
    emit(ChangingPassword());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const PasswordChanged("Password Changed"));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ChangePasswordError(error)));
    }
  }

  Future<void> _onChangeSecretAnswer(
    ChangeSecretAnswer event,
    Emitter<SecuritySettingsState> emit,
  ) async {
    emit(ChangingSecretAnswer());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const SecretAnswerChanged("Secret Answer Changed"));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ChangeSecretAnswerError(error)));
    }
  }
}
