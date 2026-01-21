import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../env/env.dart';
import '../../logger.dart';
import '../responses/general.responses.dart';

class GoogleMapRemote {
  Future<dynamic> get({required String path, required Map<String, dynamic> params}) async {
    params['key'] = Env.googleMapApiKey;

    try {
      logger.i(path);
      logger.i(params);

      final fullPath = '${Env.googleMapPlaceBasePathUrl}/$path/json';
      var url = Uri.https(Env.googleMapBaseUrl, fullPath, params);
      var response = await http.get(url, headers: {"Content-Type": "application/json"});

      logger.i(response.body);
      final result = json.decode(response.body);

      return result as Map<String, dynamic>;
    } catch (_) {
      return GeneralResponse.unknown;
    }
  }
}
