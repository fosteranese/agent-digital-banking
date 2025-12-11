part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class LoadingHistory extends HistoryState {
  const LoadingHistory();

  @override
  List<Object> get props => [];
}

class SilentLoadingHistory extends HistoryState {
  const SilentLoadingHistory();

  @override
  List<Object> get props => [];
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded({
    required this.result,
  });
  final Response<HistoryResponse> result;

  @override
  List<Object> get props => [
        result,
      ];
}

class HistoryLoadedSilently extends HistoryState {
  const HistoryLoadedSilently({
    required this.result,
  });
  final Response<HistoryResponse> result;

  @override
  List<Object> get props => [
        result,
      ];
}

class LoadHistoryError extends HistoryState {
  const LoadHistoryError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}

class SilentLoadHistoryError extends HistoryState {
  const SilentLoadHistoryError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}