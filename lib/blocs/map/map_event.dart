part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class GoogleMapAutoComplete extends MapEvent {
  const GoogleMapAutoComplete({
    required this.showSilentLoading,
    required this.id,
    required this.input,
    required this.latitude,
    required this.longitude,
  });

  final bool showSilentLoading;
  final String id;
  final String input;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [showSilentLoading, id, input, latitude, longitude];
}

class SilentGoogleMapAutoComplete extends MapEvent {
  const SilentGoogleMapAutoComplete({
    required this.input,
    required this.latitude,
    required this.longitude,
  });
  final String input;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [input, latitude, longitude];
}

class GetAddressFromLatLng extends MapEvent {
  const GetAddressFromLatLng({required this.id, required this.latitude, required this.longitude});

  final String id;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [id, latitude, longitude];
}

class GetPlace extends MapEvent {
  const GetPlace({required this.id, required this.placeId});

  final String id;
  final String placeId;

  @override
  List<Object> get props => [id, placeId];
}
