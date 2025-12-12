import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/repository/auth.repo.dart';
import 'package:my_sage_agent/data/repository/biometric.repo.dart';
import 'package:my_sage_agent/utils/response.util.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc() : super(BiometricInitial()) {
    on(_onRetrieveBiometricSettings);

    // biometric login
    on(_onBiometricLoginStatusChange);
    on(_onAutoBiometricLoginStatusChange);

    // biometric transaction
    on(_onBiometricTransactionStatusChange);
    on(_onAutoBiometricTransactionStatusChange);

    // reset biometric settings
    on(_resetBiometricSettings);
  }

  final _repo = BiometricRepo();
  final _authRepo = AuthRepo();
  bool allowBiometrics = false;
  bool isLoginEnabled = false;
  bool isAutoLoginEnabled = false;
  bool isTransactionEnabled = false;
  bool isAutoTransactionEnabled = false;

  Future<void> _onRetrieveBiometricSettings(RetrieveBiometricSettings event, Emitter<BiometricState> emit) async {
    try {
      emit(const RetrievingBiometricSettings());

      final result = await _repo.getBiometricSettings();
      final data = result.data ?? {};

      isLoginEnabled = data['biometric-login'] ?? false;
      isTransactionEnabled = data['biometric-transaction'] ?? false;
      isAutoLoginEnabled = data['biometric-auto-login'] ?? false;
      isAutoTransactionEnabled = data['biometric-auto-transaction'] ?? false;
      allowBiometrics = data['allow-transaction'] ?? false;

      emit(BiometricSettingsRetrieved(autoLogin: isAutoLoginEnabled, autoTransaction: isAutoTransactionEnabled, login: isLoginEnabled, transaction: isTransactionEnabled));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(RetrievedBiometricSettingsError(error)));
    }
  }

  Future<void> _resetBiometricSettings(ResetBiometricSettings event, Emitter<BiometricState> emit) async {
    allowBiometrics = false;
    isLoginEnabled = false;
    isAutoLoginEnabled = false;
    isTransactionEnabled = false;
    isAutoTransactionEnabled = false;
  }

  Future<void> _onBiometricLoginStatusChange(BiometricLoginStatusChange event, Emitter<BiometricState> emit) async {
    try {
      emit(ChangingBiometricLoginStatus());

      final result = await _repo.changeBiometricLoginStatus(!isLoginEnabled);
      final result1 = await _repo.changeAutoBiometricLoginStatus(!isLoginEnabled);

      isLoginEnabled = result.data ?? false;
      isAutoLoginEnabled = result1.data ?? false;

      emit(BiometricLoginStatusChanged(isLoginEnabled));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ChangeBiometricLoginStatusError(error)));
    }
  }

  Future<void> _onAutoBiometricLoginStatusChange(AutoBiometricLoginStatusChange event, Emitter<BiometricState> emit) async {
    try {
      emit(ChangingAutoBiometricLoginStatus());

      final result = await _repo.changeAutoBiometricLoginStatus(!isAutoLoginEnabled);

      if (event.pin.isNotEmpty) {
        _authRepo.saveCurrentUserPin(event.pin);
      }

      isAutoLoginEnabled = result.data ?? false;
      emit(AutoBiometricLoginStatusChanged(isAutoLoginEnabled));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ChangeAutoBiometricLoginStatusError(error)));
    }
  }

  Future<void> _onBiometricTransactionStatusChange(BiometricTransactionStatusChange event, Emitter<BiometricState> emit) async {
    try {
      emit(ChangingBiometricLoginStatus());

      final result = await _repo.changeBiometricTransactionStatus(!isTransactionEnabled);
      final result1 = await _repo.changeAutoBiometricTransactionStatus(!isTransactionEnabled);

      if (event.pin.isNotEmpty) {
        _authRepo.saveCurrentUserPin(event.pin);
      }

      isTransactionEnabled = result.data ?? false;
      isAutoTransactionEnabled = result1.data ?? false;

      emit(BiometricLoginStatusChanged(isLoginEnabled));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ChangeBiometricLoginStatusError(error)));
    }
  }

  Future<void> _onAutoBiometricTransactionStatusChange(AutoBiometricTransactionStatusChange event, Emitter<BiometricState> emit) async {
    try {
      emit(ChangingAutoBiometricLoginStatus());

      final result = await _repo.changeAutoBiometricTransactionStatus(!isAutoTransactionEnabled);

      if (event.pin.isNotEmpty) {
        _authRepo.saveCurrentUserPin(event.pin);
      }

      isAutoTransactionEnabled = result.data ?? false;
      emit(AutoBiometricLoginStatusChanged(isAutoLoginEnabled));
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(ChangeAutoBiometricLoginStatusError(error)));
    }
  }
}
