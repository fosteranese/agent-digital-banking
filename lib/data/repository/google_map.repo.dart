import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sage_agent/data/models/place_autocomplete.modal.dart';

import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/data/remote/google_map.remote.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';

final class GoogleMapRepo {
  final remote = GoogleMapRemote();

  Future<Response<LatLng>> getPlaceDetails(String placeId) async {
    // await Future.delayed(Duration(seconds: 1));

    final result = await remote.get(path: 'place/details', params: {'place_id': placeId});

    if (result['status'] == 'ZERO_RESULTS') {
      return Future.error(Response(code: '', status: 'success', message: 'No addresses found'));
    }

    final data = result['result'] as Map<String, dynamic>;
    final location = (data['geometry'] as Map<String, dynamic>)['location'] as Map<String, dynamic>;

    return Response(
      code: '',
      status: 'success',
      message: 'success',
      data: LatLng(location['lat'], location['lng']),
    );
  }

  Future<Response<PlaceAutocomplete>> getLocationFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    // await Future.delayed(Duration(seconds: 1));

    final result = await remote.get(path: 'geocode', params: {'latlng': '$latitude,$longitude'});

    if (result['status'] == 'ZERO_RESULTS') {
      return Future.error(Response(code: '', status: 'success', message: 'No addresses found'));
    }

    final plusCode = result['plus_code'] as Map<String, dynamic>;
    final compoundCode = plusCode['compound_code'].toString();
    final pieces = compoundCode.split(' ').where((item) {
      return item.trim().isNotEmpty;
    });

    final secondary = compoundCode.replaceAll(pieces.firstOrNull ?? '', '').trim();
    final address = (result['results'] as List<dynamic>).first as Map<String, dynamic>;
    final formattedAddress = address['formatted_address'].toString();
    var main = formattedAddress.replaceAll(', $secondary', '').replaceAll(secondary, '').trim();

    final location =
        (address['geometry'] as Map<String, dynamic>)['location'] as Map<String, dynamic>;

    return Response(
      code: '',
      status: 'success',
      message: 'success',
      data: PlaceAutocomplete(
        placeId: address['place_id'] as String,
        main: main,
        secondary: secondary,
        description: formattedAddress,
        location: LatLng(location['lat'] as double, location['lng'] as double),
      ),
    );
  }

  Future<Response<List<PlaceAutocomplete>>> getPlaces({
    required double latitude,
    required double longitude,
    required String search,
  }) async {
    // await Future.delayed(Duration(seconds: 1));

    final result = await remote.get(
      path: 'place/autocomplete',
      params: {'input': search, 'location': '$latitude,$longitude', 'radius': "500"},
    );

    final predictions = (result['predictions'] as List<dynamic>).map((item) {
      final structured = item['structured_formatting'] as Map<String, dynamic>;
      return PlaceAutocomplete(
        main: structured['main_text'],
        secondary: structured['secondary_text'],
        description: item['description'],
        placeId: item['place_id'],
      );
    }).toList();

    return Response(code: '', status: 'success', message: 'success', data: predictions);
  }

  Future<List<PlaceAutocomplete>?> getStoredPlaces(String action) async {
    try {
      final data = await AppUtil.db.read(action);

      if (data != null) {
        final list = (data as List<dynamic>).map((item) {
          return PlaceAutocomplete(
            main: item['address'],
            secondary: item['address'],
            description: item['description'],
            placeId: item['placeId'],
          );
        }).toList();

        return list;
      }
    } catch (_) {}

    return null;
  }

  Future<void> storePlaces(String action, List<PlaceAutocomplete> payload) async {
    return await AppUtil.db.add(key: action, payload: payload);
  }
}
