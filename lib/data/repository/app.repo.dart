import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:my_sage_agent/logger.dart';

import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/initialization_response.dart';
import '../models/user_response/user_response.dart';
import '../remote/main.remote.dart';

class AppRepo {
  final _db = Database(); //..deleteAll();
  final _fbl = MainRemote();

  Future<InitializationResponse> initiateDevice() async {
    final response = await _fbl.post(path: 'UserAccess/initialization', body: {});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = InitializationResponse.fromJson(response.data).copyWith(imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory);

    InitializationResponse newData = data;

    try {
      final getImages =
          data.walkThrough?.map((e) {
            return () async {
              final response1 = await http.get(Uri.parse("${data.imageBaseUrl}${data.imageDirectory}/${e.picture}"));

              var documentDirectory = await getApplicationSupportDirectory();
              var file = File(path.join(documentDirectory.path, e.picture));
              await file.writeAsBytes(response1.bodyBytes);
              return file.path;

              // return base64Encode(response1.bodyBytes);
            }();
          }) ??
          [];

      final images = await Future.wait(getImages);
      var imageIndex = 0;
      newData = data.copyWith(
        walkThrough: data.walkThrough?.map((e) {
          return e.copyWith(pictureBase64: images[imageIndex++]);
        }).toList(),
      );
    } catch (e) {
      logger.e(e);
    }

    saveInitialData(newData);
    return newData;
  }

  Future<InitializationResponse?> getInitialData() async {
    final data = await _db.read('initial');

    if (data != null) {
      return InitializationResponse.fromJson(data);
    }

    return null;
  }

  Future<void> saveInitialData(InitializationResponse payload) async {
    await _db.add(key: 'initial', payload: payload.toJson());
  }

  Future<UserResponse?> getCurrentUser() async {
    final data = await _db.read('current-user');

    if (data != null) {
      return UserResponse.fromMap(data);
    }

    return null;
  }
}
