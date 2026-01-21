part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

// retrieve payments

class RetrieveAccounts extends AccountEvent {
  const RetrieveAccounts({required this.routeName, required this.showSilentLoading});

  final String routeName;
  final bool showSilentLoading;

  @override
  List<Object> get props => [routeName, showSilentLoading];
}

class RefreshRetrieveAccounts extends AccountEvent {
  const RefreshRetrieveAccounts(this.routeName);

  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrieveAccounts extends AccountEvent {
  const SilentRetrieveAccounts();

  @override
  List<Object> get props => [];
}

// retrieve mini statement

class RetrieveMiniStatement extends AccountEvent {
  const RetrieveMiniStatement({
    required this.routeName,
    required this.source,
    required this.sourceValue,
    this.startDate,
    this.endDate,
  });

  final String routeName;
  final Source source;
  final String sourceValue;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [routeName, source, sourceValue, startDate, endDate];
}

class SilentRetrieveMiniStatement extends AccountEvent {
  const SilentRetrieveMiniStatement({required this.source, this.startDate, this.endDate});

  final Source source;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [source, startDate, endDate];
}
