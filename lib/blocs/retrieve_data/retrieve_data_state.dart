part of 'retrieve_data_bloc.dart';

sealed class RetrieveDataState extends Equatable {
  final String id;
  final String action;
  final RetrieveDataEvent? event;

  const RetrieveDataState({
    required this.id,
    required this.action,
    this.event,
  });

  @override
  List<Object?> get props => [id, action, event];
}

final class RetrieveDataInitial extends RetrieveDataState {
  const RetrieveDataInitial({
    required super.id,
    required super.action,
  });

  @override
  List<Object?> get props => [id, action];
}

final class RetrievingData extends RetrieveDataState {
  const RetrievingData({
    required super.id,
    required super.action,
    required super.event,
  });

  @override
  List<Object?> get props => [id, action, event];
}

final class RetrievingDataSilently
    extends RetrieveDataState {
  const RetrievingDataSilently({
    required super.id,
    required super.action,
    required super.event,
  });

  @override
  List<Object?> get props => [id, action, event];
}

final class RetrieveDataError extends RetrieveDataState {
  final Response error;

  const RetrieveDataError({
    required super.id,
    required super.action,
    required super.event,
    required this.error,
  });

  @override
  List<Object?> get props => [id, action, event, error];
}

final class DataRetrieved<T> extends RetrieveDataState {
  final T data;
  final bool stillLoading;

  const DataRetrieved({
    required this.data,
    required super.id,
    required super.action,
    required super.event,
    this.stillLoading = false,
  });

  @override
  List<Object?> get props => [
    id,
    action,
    data,
    event,
    stillLoading,
  ];
}