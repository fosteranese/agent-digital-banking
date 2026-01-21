part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class GoogleMapAutoCompleting extends MapState {
  const GoogleMapAutoCompleting();

  @override
  List<Object> get props => [];
}

class SilentGoogleMapAutoCompleting extends MapState {
  const SilentGoogleMapAutoCompleting();

  @override
  List<Object> get props => [];
}

class GoogleMapAutoCompleted extends MapState {
  const GoogleMapAutoCompleted({required this.routeName, required this.result});
  final String routeName;
  final Response<GoogleMapAutoCompleteResponse> result;

  @override
  List<Object> get props => [routeName, result];
}

class GoogleMapAutoCompletedSilently extends MapState {
  const GoogleMapAutoCompletedSilently({required this.result});
  final Response<GoogleMapAutoCompleteResponse> result;

  @override
  List<Object> get props => [result];
}

class GoogleMapAutoCompleteError extends MapState {
  const GoogleMapAutoCompleteError({required this.routeName, required this.result});

  final String routeName;
  final Response<dynamic> result;

  @override
  List<Object> get props => [routeName, result];
}

class SilentGoogleMapAutoCompleteError extends MapState {
  const SilentGoogleMapAutoCompleteError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class GettingAddressFromLatLng extends MapState {
  const GettingAddressFromLatLng(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class AddressFromLatLngGotten extends MapState {
  const AddressFromLatLngGotten({required this.id, required this.result});
  final String id;
  final Response<PlaceResponse> result;

  @override
  List<Object> get props => [id, result];
}

class GetAddressFromLatLngError extends MapState {
  const GetAddressFromLatLngError({required this.id, required this.result});

  final String id;
  final Response<dynamic> result;

  @override
  List<Object> get props => [id, result];
}

class GettingPlace extends MapState {
  const GettingPlace(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class PlaceGotten extends MapState {
  const PlaceGotten({required this.id, required this.result});
  final String id;
  final Response<PlaceResponse> result;

  @override
  List<Object> get props => [id, result];
}

class GetPlaceError extends MapState {
  const GetPlaceError({required this.id, required this.result});

  final String id;
  final Response<dynamic> result;

  @override
  List<Object> get props => [id, result];
}
