import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/google_map/auto_complete_response.dart';
import '../models/map/geocode_response.dart';
import '../models/map/place_response.dart';
import '../models/response.modal.dart';
import '../remote/google_map.remote.dart';

class MapRepo {
  final _db = Database();
  final _map = GoogleMapRemote();
  final _radius = '500';
  final _types = 'establishment';

  Future<Response<GoogleMapAutoCompleteResponse>?> getStoredAutoComplete({
    required String input,
    required double latitude,
    required double longitude,
  }) async {
    final result = await _db.read('google-map/autocomplete/$input/$latitude/$longitude');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = GoogleMapAutoCompleteResponse.fromMap(result['data'] as Map<String, dynamic>);
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: data,
    );
  }

  Future<Response<GoogleMapAutoCompleteResponse>> autoComplete({
    required String input,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _map.get(
      path: 'place/autocomplete',
      params: {
        'input': input,
        'location': '$latitude,$longitude',
        'radius': _radius,
        'types': _types,
      },
    );

    if (response is Response<dynamic>) {
      return Future.error(response);
    }

    final data = GoogleMapAutoCompleteResponse.fromMap(response);
    if (data.predictions?.isNotEmpty ?? false) {
      _db.add(
        key: 'google-map/autocomplete/$input/$latitude/$longitude',
        payload: {
          'code': StatusConstants.success,
          'status': StatusConstants.success,
          'data': response['predications'],
          'message': 'predications retrieved',
        },
      );
    }

    if (data.status != 'OK' && data.status != 'ZERO_RESULTS') {
      return Future.error(
        const Response(
          code: StatusConstants.failed,
          status: StatusConstants.failed,
          message: 'Could not find place',
        ),
      );
    }

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'autocomplete done',
      data: data,
    );
  }

  Future<Response<GeocodeResponse>> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _map.get(path: 'geocode', params: {'latlng': '$latitude,$longitude'});

    if (response is Response<dynamic>) {
      return Future.error(response);
    }

    final data = GeocodeResponse.fromMap(response);

    if (data.status != 'OK' && data.status != 'ZERO_RESULTS') {
      return Future.error(
        const Response(
          code: StatusConstants.failed,
          status: StatusConstants.failed,
          message: 'Could not find place',
        ),
      );
    }

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'place found',
      data: data,
    );
  }

  Future<Response<PlaceResponse>> getPlace(String placeId) async {
    final response = await _map.get(path: 'place/details', params: {'place_id': placeId});

    if (response is Response<dynamic>) {
      return Future.error(response);
    }

    final data = PlaceResponse.fromMap(response);

    if (data.status != 'OK' && data.status != 'ZERO_RESULTS') {
      return Future.error(
        const Response(
          code: StatusConstants.failed,
          status: StatusConstants.failed,
          message: 'Could not find place',
        ),
      );
    }

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'place found',
      data: data,
    );
  }
}
