part of 'setup_bloc.dart';

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class RetrieveAccountOpeningLOVs extends SetupEvent {
  const RetrieveAccountOpeningLOVs({
    required this.routeName,
  });

  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class RetrieveAccessCode extends SetupEvent {
  const RetrieveAccessCode({
    required this.routeName,
    required this.registrationId,
    required this.phoneNumber,
    required this.emailAddress,
    required this.action,
  });

  final String routeName;
  final String registrationId;
  final String phoneNumber;
  final String emailAddress;
  final String action;

  @override
  List<Object> get props => [
        routeName,
        registrationId,
        phoneNumber,
        emailAddress,
        action,
      ];
}