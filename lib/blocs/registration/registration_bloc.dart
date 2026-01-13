import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/repository/registration.repo.dart';
import 'package:my_sage_agent/utils/response.util.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on(_onSavePersonalInfo);
    on(_onSaveResidentialAddress);
    on(_onVerifyPicture);
    on(_onManualVerification);
  }

  final _repo = RegistrationRepo();
  String? personalInfoToken;
  String? residentialAddressToken;

  Future<void> _onSavePersonalInfo(SavePersonalInfo event, Emitter<RegistrationState> emit) async {
    try {
      emit(SavingPersonalInfo());

      final result = await _repo.savePersonalInfo(
        firstName: event.firstName,
        lastName: event.lastName,
        gender: event.gender,
        phoneNumber: event.phoneNumber,
        emailAddress: event.emailAddress,
      );
      personalInfoToken = result;

      emit(PersonalInfoSaved(token: personalInfoToken!));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SavePersonalInfoError(error: error)));
    }
  }

  Future<void> _onSaveResidentialAddress(
    SaveResidentialAddress event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(SavingResidentialAddress());

      final result = await _repo.saveResidentialAddress(
        token: personalInfoToken!,
        address1: event.address1,
        address2: event.address2,
        region: event.region,
        cityOrTown: event.cityOrTown,
      );
      residentialAddressToken = result;

      emit(ResidentialAddressSaved(token: residentialAddressToken!));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SaveResidentialAddressError(error: error)));
    }
  }

  Future<void> _onVerifyPicture(VerifyPicture event, Emitter<RegistrationState> emit) async {
    try {
      emit(VerifyingPicture());

      final result = await _repo.verifyPicture(
        token: residentialAddressToken!,
        picture: event.picture,
      );

      emit(PictureVerified(response: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(VerifyPictureError(error: error)));
    }
  }

  Future<void> _onManualVerification(
    ManualVerification event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(VerifyingManually());

      await _repo.manualVerification(
        token: residentialAddressToken!,
        cardFront: event.cardFront,
        cardBack: event.cardBack,
      );

      emit(ManuallyVerified());
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ManualVerificationError(error: error)));
    }
  }
}
