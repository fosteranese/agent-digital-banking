part of 'setup_bloc.dart';

abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends SetupState {}

class RetrievingAccountOpeningLOVs extends SetupState {
  const RetrievingAccountOpeningLOVs(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingAccountOpeningLOVs extends SetupState {
  const SilentRetrievingAccountOpeningLOVs();

  @override
  List<Object> get props => [];
}

class AccountOpeningLOVsRetrieved extends SetupState {
  const AccountOpeningLOVsRetrieved({required this.result, required this.routeName});
  final Response<AccountOpeningLovs> result;
  final String routeName;
  @override
  List<Object> get props => [result, routeName];
}

class AccountOpeningLOVsRetrievedSilently extends SetupState {
  const AccountOpeningLOVsRetrievedSilently(this.result);
  final Response<AccountOpeningLovs> result;

  @override
  List<Object> get props => [result];
}

class RetrieveAccountOpeningLOVsError extends SetupState {
  const RetrieveAccountOpeningLOVsError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrieveAccountOpeningLOVsError extends SetupState {
  const SilentRetrieveAccountOpeningLOVsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class RetrievingAccessCode extends SetupState {
  const RetrievingAccessCode(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class AccessCodeRetrieved extends SetupState {
  const AccessCodeRetrieved({required this.result, required this.routeName});
  final Response<dynamic> result;
  final String routeName;
  @override
  List<Object> get props => [result, routeName];
}

class RetrieveAccessCodeError extends SetupState {
  const RetrieveAccessCodeError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}
