part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

// retrieve accounts

class RetrievingAccounts extends AccountState {
  const RetrievingAccounts(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingAccounts extends AccountState {
  const SilentRetrievingAccounts();

  @override
  List<Object> get props => [];
}

class AccountsRetrieved extends AccountState {
  const AccountsRetrieved({
    required this.result,
    required this.routeName,
  });
  final Response<List<Account>> result;
  final String routeName;
  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class AccountsRetrievedSilently extends AccountState {
  const AccountsRetrievedSilently(this.result);
  final Response<List<Account>> result;

  @override
  List<Object> get props => [
        result,
      ];
}

class RetrieveAccountsError extends AccountState {
  const RetrieveAccountsError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveAccountsError extends AccountState {
  const SilentRetrieveAccountsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}

// retrieve mini statement

class RetrievingMiniStatement extends AccountState {
  const RetrievingMiniStatement(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingMiniStatement extends AccountState {
  const SilentRetrievingMiniStatement();

  @override
  List<Object> get props => [];
}

class MiniStatementRetrieved extends AccountState {
  const MiniStatementRetrieved({
    required this.result,
    required this.routeName,
    required this.source,
  });

  final Response<MiniStatement> result;
  final Source source;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class MiniStatementRetrievedSilently extends AccountState {
  const MiniStatementRetrievedSilently({
    required this.result,
    required this.source,
  });

  final Response<MiniStatement> result;
  final Source source;

  @override
  List<Object> get props => [
        result,
        source,
      ];
}

class RetrieveMiniStatementError extends AccountState {
  const RetrieveMiniStatementError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveMiniStatementError extends AccountState {
  const SilentRetrieveMiniStatementError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}