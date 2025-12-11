import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/process_request.model.dart';
import '../models/response.modal.dart';
import '../models/schedule/schedules.dart';
import '../remote/main.remote.dart';

class ScheduleRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<SchedulesData>?> getStoredSchedules() async {
    final result = await _db.read('schedules');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = SchedulesData.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<SchedulesData>> retrieveSchedules() async {
    final response = await _fbl.post(
      path: 'Schedule/getUserSchedules',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = SchedulesData.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: 'schedules', payload: {
      'data': response.data,
      'imageBaseUrl': response.imageBaseUrl,
      'imageDirectory': response.imageDirectory,
      'timeStamp': response.timeStamp,
      'code': response.code,
      'status': response.status,
      'message': response.message,
    });

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

  Future<Response<List<Schedules>>> deleteSchedule(String scheduleId) async {
    final response = await _fbl.post(
      path: 'Schedule/deleteSchedule',
      body: {
        "scheduleId": scheduleId,
        "status": 0,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final store = await getStoredSchedules();
    final data = store?.data?.schedules?.where((element) => element.schedule?.scheduleId != scheduleId).toList() ?? [];
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

  Future<Response> addSchedule({
    required Map<String, dynamic> payload,
    required Map<String, dynamic> schedulePayload,
    required ProcessRequestModel request,
  }) async {
    final response = await _fbl.post(
      path: 'Payee/addPayee',
      body: {
        'activityId': request.activityId,
        'formId': request.formId,
        'formData': payload,
        'schedule': schedulePayload,
        'paymentMode': request.paymentMode,
        "auth": request.auth.toMap(),
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }
}