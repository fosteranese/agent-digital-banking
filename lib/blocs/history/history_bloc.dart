import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/main.dart';

import '../../data/models/history/activity.dart';
import '../../data/models/history/history.response.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/history.repo.dart';
import '../../utils/response.util.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on(_onLoadHistory);
    on(_onSilentLoadHistory);
    on(_onLoadAllHistory);
    on(_onFilterHistory);
  }

  final _repo = HistoryRepo();
  void Function() replay = () {};
  Response<HistoryResponse> history = const Response(code: '', status: '', message: '', data: null);

  Future<void> _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) async {
    replay = () {
      MyApp.navigatorKey.currentContext!.read<HistoryBloc>().add(event);
    };
    Response<HistoryResponse>? stored;
    try {
      if (history.data?.request?.isNotEmpty ?? false) {
        stored = history;
        emit(HistoryLoaded(result: history));

        if (event.showSilentLoading) {
          await Future.delayed(const Duration(milliseconds: 200));
          emit(const SilentLoadingHistory());
        }
      } else {
        emit(const LoadingHistory());

        stored = await _repo.getStoredHistory();
        if (stored?.data?.request?.isNotEmpty ?? false) {
          history = stored!;
          emit(HistoryLoaded(result: stored));

          if (event.showSilentLoading) {
            await Future.delayed(const Duration(milliseconds: 200));
            emit(const SilentLoadingHistory());
          }
        } else if (history.data?.request?.isNotEmpty ?? false) {
          emit(HistoryLoaded(result: history));

          if (event.showSilentLoading) {
            await Future.delayed(const Duration(milliseconds: 200));
            emit(const SilentLoadingHistory());
          }
        }
      }

      final result = await _repo.loadHistory();
      if (result.data != null) {
        history = result;
      }

      if (stored?.data?.request?.isEmpty ?? false) {
        emit(HistoryLoaded(result: history));
      } else {
        emit(HistoryLoadedSilently(result: history));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.activity?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(LoadHistoryError(error)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentLoadHistoryError(error)));
      }
    }
  }

  Future<void> _onSilentLoadHistory(SilentLoadHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(const SilentLoadingHistory());

      final result = await _repo.loadHistory();
      if (result.data != null) {
        history = result;
      }

      emit(HistoryLoadedSilently(result: history));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentLoadHistoryError(error)));
    }
  }

  Future<void> _onFilterHistory(FilterHistory event, Emitter<HistoryState> emit) async {
    replay = () {
      MyApp.navigatorKey.currentContext!.read<HistoryBloc>().add(event);
    };

    try {
      emit(const LoadingHistory());
      final result = await _repo.filterHistory(event.activity);
      emit(HistoryLoaded(result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(LoadHistoryError(error)));
    }
  }

  Future<void> _onLoadAllHistory(LoadAllHistory event, Emitter<HistoryState> emit) async {
    replay = () {
      MyApp.navigatorKey.currentContext!.read<HistoryBloc>().add(event);
    };

    try {
      emit(const LoadingHistory());
      final result = await _repo.loadHistory();
      emit(HistoryLoaded(result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(LoadHistoryError(error)));
    }
  }
}
