import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/account/account.dart';
import '../../data/models/account/mini_statement.dart';
import '../../data/models/account/source.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/account.repo.dart';
import '../../utils/response.util.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on(_onRetrieveAccounts);
    on(_onSilentRetrieveAccounts);
    on(_onRefreshRetrieveAccounts);

    on(_onRetrieveMiniStatement);
    on(_onSilentRetrieveMiniStatement);
  }

  final _repo = AccountRepo();

  Response<List<Account>> accounts = const Response(
    code: 'success',
    status: 'success',
    message: 'Retrieved',
    data: [],
  );

  Map<String, Response<MiniStatement>> miniStatement = {};

  Future<void> _onRetrieveAccounts(RetrieveAccounts event, Emitter<AccountState> emit) async {
    Response<List<Account>>? stored;
    try {
      emit(RetrievingAccounts(event.routeName));

      stored = await _repo.getStoredAccounts();

      if (stored != null && (stored.data?.isNotEmpty ?? false)) {
        accounts = stored;
        emit(AccountsRetrieved(result: accounts, routeName: event.routeName));

        if (event.showSilentLoading) {
          await Future.delayed(const Duration(milliseconds: 200));
          emit(const SilentRetrievingAccounts());
        }
      } else if (accounts.data != null) {
        if (event.showSilentLoading) {
          await Future.delayed(const Duration(milliseconds: 200));
          emit(const SilentRetrievingAccounts());
        }
      }

      final result = await _repo.retrieveAccounts();
      accounts = result;

      if (stored == null || (stored.data?.isEmpty ?? false)) {
        emit(AccountsRetrieved(result: accounts, routeName: event.routeName));
      } else {
        emit(AccountsRetrievedSilently(accounts));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(RetrieveAccountsError(result: error, routeName: event.routeName)),
        );
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveAccountsError(error)));
      }
    }
  }

  Future<void> _onSilentRetrieveAccounts(
    SilentRetrieveAccounts event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(const SilentRetrievingAccounts());
      final result = await _repo.retrieveAccounts();
      accounts = result;

      emit(AccountsRetrievedSilently(result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveAccountsError(error)));
    }
  }

  Future<void> _onRefreshRetrieveAccounts(
    RefreshRetrieveAccounts event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(RetrievingAccounts(event.routeName));

      final result = await _repo.retrieveAccounts();
      accounts = result;

      emit(AccountsRetrieved(result: accounts, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(RetrieveAccountsError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onRetrieveMiniStatement(
    RetrieveMiniStatement event,
    Emitter<AccountState> emit,
  ) async {
    Response<MiniStatement>? stored;
    final mini = miniStatement[event.sourceValue];

    try {
      if (mini?.data?.transactions?.isNotEmpty ?? false) {
        stored = mini;
        emit(
          MiniStatementRetrieved(result: stored!, routeName: event.routeName, source: event.source),
        );

        await Future.delayed(const Duration(milliseconds: 200));
        emit(const SilentRetrievingMiniStatement());
      } else {
        emit(RetrievingMiniStatement(event.routeName));

        stored = await _repo.getStoredMiniStatement(event.source);
        if (stored?.data?.transactions?.isNotEmpty ?? false) {
          miniStatement[event.sourceValue] = stored!;
          emit(
            MiniStatementRetrieved(
              result: stored,
              routeName: event.routeName,
              source: event.source,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 200));
          emit(const SilentRetrievingMiniStatement());
        } else if (mini?.data?.transactions?.isNotEmpty ?? false) {
          emit(
            MiniStatementRetrieved(result: mini!, routeName: event.routeName, source: event.source),
          );

          await Future.delayed(const Duration(milliseconds: 200));
          emit(const SilentRetrievingMiniStatement());
        }
      }

      final result = await _repo.retrieveMiniStatement(
        source: event.source,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (result.data != null) {
        miniStatement[event.sourceValue] = result;
      }

      if (stored?.data?.transactions?.isEmpty ?? true) {
        emit(
          MiniStatementRetrieved(result: result, routeName: event.routeName, source: event.source),
        );
      } else {
        emit(MiniStatementRetrievedSilently(result: result, source: event.source));
      }
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(RetrieveMiniStatementError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onSilentRetrieveMiniStatement(
    SilentRetrieveMiniStatement event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(const SilentRetrievingMiniStatement());
      final result = await _repo.retrieveMiniStatement(
        source: event.source,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(MiniStatementRetrievedSilently(result: result, source: event.source));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveMiniStatementError(error)));
    }
  }
}
