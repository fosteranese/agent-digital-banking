part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class SavePersonalInfo extends RegistrationEvent {
  const SavePersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber,
    required this.emailAddress,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String phoneNumber;
  final String emailAddress;

  @override
  List<Object> get props => [firstName, lastName, gender, phoneNumber, emailAddress];
}

class SaveResidentialAddress extends RegistrationEvent {
  const SaveResidentialAddress({
    required this.address1,
    this.address2,
    required this.region,
    required this.cityOrTown,
  });

  final String address1;
  final String? address2;
  final String region;
  final String cityOrTown;

  @override
  List<Object?> get props => [address1, address2, region, cityOrTown];
}

class VerifyPicture extends RegistrationEvent {
  const VerifyPicture({required this.picture});

  final String picture;

  @override
  List<Object?> get props => [picture];
}

class ManualVerification extends RegistrationEvent {
  const ManualVerification({required this.id, required this.cardFront, required this.cardBack});

  final String id;
  final String cardFront;
  final String cardBack;

  @override
  List<Object?> get props => [id, cardFront, cardBack];
}
