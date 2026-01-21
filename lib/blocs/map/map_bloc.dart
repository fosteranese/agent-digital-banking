import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/status.const.dart';
import '../../data/models/google_map/auto_complete_response.dart';
import '../../data/models/map/place_response.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/map.repo.dart';
import '../../utils/response.util.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on(_onGoogleAutoComplete);
    on(_onSilentGoogleAutoComplete);
    on(_onGetAddressFromLatLng);
    on(_onGetPlace);
  }

  final _repo = MapRepo();
  Response<GoogleMapAutoCompleteResponse> records = const Response(
    code: '',
    status: '',
    message: '',
    data: null,
  );
  Map<String, Response<GoogleMapAutoCompleteResponse>> recordsMap = {};

  Future<void> _onGoogleAutoComplete(GoogleMapAutoComplete event, Emitter<MapState> emit) async {
    Response<GoogleMapAutoCompleteResponse>? stored;
    final key = 'google-map/autocomplete/$event.input/${event.latitude}/${event.longitude}';
    try {
      if (recordsMap[key]?.data?.predictions?.isNotEmpty ?? false) {
        records = recordsMap[key]!;
        stored = recordsMap[key];
        emit(GoogleMapAutoCompleted(routeName: event.id, result: records));

        if (event.showSilentLoading) {
          emit(const SilentGoogleMapAutoCompleting());
        }
      } else {
        emit(const GoogleMapAutoCompleting());

        stored = await _repo.getStoredAutoComplete(
          input: event.input,
          latitude: event.latitude,
          longitude: event.longitude,
        );

        if (stored?.data?.predictions?.isNotEmpty ?? false) {
          records = stored!;
          emit(GoogleMapAutoCompleted(routeName: event.id, result: stored));
        }

        if (event.showSilentLoading) {
          emit(const SilentGoogleMapAutoCompleting());
        }
      }

      final result = await _repo.autoComplete(
        input: event.input,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      records = result;
      stored = result;
      recordsMap[key] = result;

      if (stored.data?.predictions?.isEmpty ?? false) {
        emit(GoogleMapAutoCompleted(routeName: event.id, result: records));
      } else {
        emit(GoogleMapAutoCompletedSilently(result: records));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.predictions?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(GoogleMapAutoCompleteError(result: error, routeName: event.id)),
        );
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentGoogleMapAutoCompleteError(error)));
      }
    }
  }

  Future<void> _onSilentGoogleAutoComplete(
    SilentGoogleMapAutoComplete event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(const SilentGoogleMapAutoCompleting());
      final result = await _repo.autoComplete(
        input: event.input,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      emit(GoogleMapAutoCompletedSilently(result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentGoogleMapAutoCompleteError(error)));
    }
  }

  Future<void> _onGetAddressFromLatLng(GetAddressFromLatLng event, Emitter<MapState> emit) async {
    try {
      emit(GettingAddressFromLatLng(event.id));

      final result = await _repo.getAddress(latitude: event.latitude, longitude: event.longitude);

      if (result.data?.results?.isEmpty ?? true) {
        emit(
          GetAddressFromLatLngError(
            result: const Response(
              code: StatusConstants.error,
              status: StatusConstants.error,
              message: 'Could not get your current location',
            ),
            id: event.id,
          ),
        );
        return;
      }

      final result1 = await _repo.getPlace(result.data!.results!.first.placeId ?? '');
      emit(AddressFromLatLngGotten(id: event.id, result: result1));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(GetAddressFromLatLngError(result: error, id: event.id)),
      );
    }
  }

  Future<void> _onGetPlace(GetPlace event, Emitter<MapState> emit) async {
    try {
      emit(GettingPlace(event.id));

      final result = await _repo.getPlace(event.placeId);

      emit(PlaceGotten(id: event.id, result: result));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(GetPlaceError(result: error, id: event.id)));
    }
  }
}
