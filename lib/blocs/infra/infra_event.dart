part of 'infra_bloc.dart';

abstract class InfraEvent extends Equatable {
  const InfraEvent();

  @override
  List<Object> get props => [];
}

class LoadBankInfra extends InfraEvent {
  const LoadBankInfra({
    this.showSilentLoading = true,
    required this.id,
  });

  final bool showSilentLoading;
  final String id;

  @override
  List<Object> get props => [
        showSilentLoading,
        id,
      ];
}

class SilentLoadBankInfra extends InfraEvent {
  const SilentLoadBankInfra();

  @override
  List<Object> get props => [];
}