part of 'infra_bloc.dart';

abstract class InfraState extends Equatable {
  const InfraState();

  @override
  List<Object> get props => [];
}

class MapInitial extends InfraState {}

class LoadingBankInfra extends InfraState {
  const LoadingBankInfra();

  @override
  List<Object> get props => [];
}

class SilentLoadingBankInfra extends InfraState {
  const SilentLoadingBankInfra();

  @override
  List<Object> get props => [];
}

class BankInfraLoaded extends InfraState {
  const BankInfraLoaded({required this.id, required this.locators, required this.infraTypes});

  final String id;
  final List<Locators> locators;
  final List<InfraType> infraTypes;

  @override
  List<Object> get props => [id, locators, infraTypes];
}

class BankInfraLoadedSilently extends InfraState {
  const BankInfraLoadedSilently({required this.locators, required this.infraTypes});

  final List<Locators> locators;
  final List<InfraType> infraTypes;

  @override
  List<Object> get props => [locators, infraTypes];
}

class LoadBankInfraError extends InfraState {
  const LoadBankInfraError({required this.routeName, required this.result});

  final String routeName;
  final Response<dynamic> result;

  @override
  List<Object> get props => [routeName, result];
}

class SilentLoadBankInfraError extends InfraState {
  const SilentLoadBankInfraError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}
