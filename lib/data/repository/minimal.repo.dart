import '../../constants/status.const.dart';
import '../models/minimal_response.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class MinimalRepo {
  final _fbl = MainRemote();

  Future<Response<MinimalResponse>> startNewSession() async {
    final response = await _fbl.post(
      path: 'Minified/router',
      body: {
        'requestType': '',
        'minifiedSessionId': '',
        'userInput': '',
        'auth': {
          'secretAnswer': '',
          'securityanswer': '',
          'otp': '',
          'pin': '',
        }
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = MinimalResponse.fromMap(response.data);
    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<MinimalResponse>> replySession({
    required String reply,
    required MinimalResponse session,
  }) async {
    final response = await _fbl.post(
      path: 'Minified/router',
      body: {
        'requestType': session.requestType,
        'minifiedSessionId': session.minifiedSessionId,
        'userInput': reply,
        'auth': {
          'secretAnswer': '',
          'securityanswer': '',
          'otp': '',
          'pin': '',
        }
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = MinimalResponse.fromMap(response.data);
    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }
}