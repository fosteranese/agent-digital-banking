import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/infra/bank_infra.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/bank_infra.repo.dart';
import '../../utils/response.util.dart';

part 'infra_event.dart';
part 'infra_state.dart';

class InfraBloc extends Bloc<InfraEvent, InfraState> {
  InfraBloc() : super(MapInitial()) {
    on(_onLoadBankInfra);
    on(_onSilentLoadBankInfra);
  }

  final _repo = BankInfraRepo();
  List<Locators> locators = [];
  List<InfraType> infraTypes = [];

  Future<void> _onLoadBankInfra(LoadBankInfra event, Emitter<InfraState> emit) async {
    List<Locators> locs = [];
    List<InfraType> liveTypes = [];
    try {
      if (locators.isNotEmpty && infraTypes.isNotEmpty) {
        emit(BankInfraLoaded(id: event.id, locators: locators, infraTypes: infraTypes));

        if (event.showSilentLoading) {
          await Future.delayed(const Duration(seconds: 0));
          emit(const SilentLoadingBankInfra());
        }
      } else {
        final types = await _repo.getStoredInfraTypes();
        if (types?.isNotEmpty ?? false) {
          infraTypes = types!;
        }
        final saveLocs = await _repo.getStoredLocators();
        if (saveLocs?.isNotEmpty ?? false) {
          locators = saveLocs!;
        }

        if (locators.isNotEmpty && infraTypes.isNotEmpty) {
          emit(BankInfraLoaded(id: event.id, locators: locators, infraTypes: infraTypes));

          if (event.showSilentLoading) {
            await Future.delayed(const Duration(seconds: 0));
            emit(const SilentLoadingBankInfra());
          }
        } else {
          emit(const LoadingBankInfra());
        }
      }

      final result = await _repo.loadBankInfraTypes();
      liveTypes = result.data ?? [] as List<InfraType>;
      for (var infra in liveTypes) {
        final result1 = await _repo.loadBankInfra(infra.typeId ?? '');
        locs = locs + (result1.data?.locators ?? <Locators>[]);
      }

      _repo.saveLocations(locs);

      if (locators.isNotEmpty && (infraTypes.isNotEmpty)) {
        emit(BankInfraLoadedSilently(infraTypes: liveTypes, locators: locs));
      } else {
        emit(BankInfraLoaded(id: event.id, infraTypes: liveTypes, locators: locs));
      }

      infraTypes = liveTypes;
      locators = locs;
    } catch (ex) {
      if (locs.isNotEmpty && (liveTypes.isNotEmpty)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(LoadBankInfraError(result: error, routeName: event.id)),
        );
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentLoadBankInfraError(error)));
      }
    }
  }

  Future<void> _onSilentLoadBankInfra(SilentLoadBankInfra event, Emitter<InfraState> emit) async {
    List<Locators> locs = [];
    List<InfraType> liveTypes = [];
    try {
      emit(const SilentLoadingBankInfra());

      final result = await _repo.loadBankInfraTypes();
      liveTypes = result.data ?? [] as List<InfraType>;
      for (var infra in liveTypes) {
        final result1 = await _repo.loadBankInfra(infra.typeId ?? '');
        locs = locs + (result1.data?.locators ?? <Locators>[]);
      }

      emit(BankInfraLoadedSilently(infraTypes: liveTypes, locators: locs));

      infraTypes = liveTypes;
      locators = locs;
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentLoadBankInfraError(error)));
    }
  }
}
