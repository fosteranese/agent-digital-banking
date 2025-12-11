part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory(this.showSilentLoading);
  final bool showSilentLoading;

  @override
  List<Object> get props => [
        showSilentLoading,
      ];
}

class SilentLoadHistory extends HistoryEvent {
  const SilentLoadHistory();

  @override
  List<Object> get props => [];
}

class FilterHistory extends HistoryEvent {
  const FilterHistory(this.activity);
  final Activity activity;

  @override
  List<Object> get props => [
        activity,
      ];
}

class LoadAllHistory extends HistoryEvent {
  const LoadAllHistory();

  @override
  List<Object> get props => [];
}