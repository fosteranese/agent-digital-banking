import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/history/activity.dart';
import '../models/history/history.response.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class HistoryRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<HistoryResponse>?>
  getStoredHistory() async {
    final result = await _db.read('history');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = HistoryResponse.fromMap(
      result['data'] as Map<String, dynamic>,
    );
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: data,
      imageBaseUrl: result['imageBaseUrl']?.toString(),
      imageDirectory: result['imageDirectory']?.toString(),
      timeStamp: result['timeStamp']?.toString(),
    );
  }

  Future<Response<HistoryResponse>> loadHistory() async {
    final response = await _fbl.post(
      path: 'MyAccount/history',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = HistoryResponse.fromMap(
      response.data as Map<String, dynamic>,
    );
    storeHistory(response);

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

  Future<Response<HistoryResponse>> filterHistory(
    Activity activity,
  ) async {
    final response = await _fbl.post(
      path: 'MyAccount/history',
      body: {'activityId': activity.activityId},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = HistoryResponse.fromMap(
      response.data as Map<String, dynamic>,
    );
    storeHistory(response);

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

  void storeHistory(Response<dynamic> response) {
    _db.add(
      key: 'history',
      payload: {
        'data': response.data,
        'imageBaseUrl': response.imageBaseUrl,
        'imageDirectory': response.imageDirectory,
        'timeStamp': response.timeStamp,
        'code': response.code,
        'status': response.status,
        'message': response.message,
      },
    );
  }
}
