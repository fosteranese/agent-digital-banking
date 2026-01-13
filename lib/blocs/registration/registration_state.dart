part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class SavingPersonalInfo extends RegistrationState {
  const SavingPersonalInfo();
  @override
  List<Object> get props => [];
}

class PersonalInfoSaved extends RegistrationState {
  const PersonalInfoSaved({required this.token});

  final String token;

  @override
  List<Object> get props => [token];
}

class SavePersonalInfoError extends RegistrationState {
  const SavePersonalInfoError({required this.error});

  final Response<dynamic> error;

  @override
  List<Object> get props => [error];
}

class SavingResidentialAddress extends RegistrationState {
  const SavingResidentialAddress();

  @override
  List<Object> get props => [];
}

class ResidentialAddressSaved extends RegistrationState {
  const ResidentialAddressSaved({required this.token});

  final String token;

  @override
  List<Object> get props => [token];
}

class SaveResidentialAddressError extends RegistrationState {
  const SaveResidentialAddressError({required this.error});

  final Response<dynamic> error;

  @override
  List<Object> get props => [error];
}

class VerifyingPicture extends RegistrationState {
  const VerifyingPicture();

  @override
  List<Object> get props => [];
}

class PictureVerified extends RegistrationState {
  const PictureVerified({required this.response});
  final Response response;

  @override
  List<Object> get props => [response];
}

class VerifyPictureError extends RegistrationState {
  const VerifyPictureError({required this.error});

  final Response<dynamic> error;

  @override
  List<Object> get props => [error];
}

class VerifyingManually extends RegistrationState {
  const VerifyingManually();

  @override
  List<Object> get props => [];
}

class ManuallyVerified extends RegistrationState {
  const ManuallyVerified();

  @override
  List<Object> get props => [];
}

class ManualVerificationError extends RegistrationState {
  const ManualVerificationError({required this.error});

  final Response<dynamic> error;

  @override
  List<Object> get props => [error];
}
