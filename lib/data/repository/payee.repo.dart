import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/payee/payees_response.dart';
import '../models/process_request.model.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class PayeeRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<PayeesResponse>?>
  getStoredPayees() async {
    final result = await _db.read('all-payees');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = PayeesResponse.fromMap(
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

  Future<Response<List<Payees>>?> getStoredFormPayees(
    String formId,
  ) async {
    final result = await _db.read('form-payees/$formId');

    if (result == null || result['list'] == null) {
      return null;
    }

    final List<Payees> list = result['list'] != null
        ? (result['list'] as List<dynamic>)
              .map((e) => Payees.fromMap(e))
              .toList()
        : [];
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: list,
      imageBaseUrl: result['imageBaseUrl']?.toString(),
      imageDirectory: result['imageDirectory']?.toString(),
      timeStamp: result['timeStamp']?.toString(),
    );
  }

  Future<Response<PayeesResponse>> retrievePayees() async {
    final response = await _fbl.post(
      path: 'Payee/getAllPayees',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = PayeesResponse.fromMap(
      response.data as Map<String, dynamic>,
    );
    if (data.payees?.isNotEmpty ?? false) {
      storePayees(response);
    }

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

  Future<Response<List<Payees>>> retrieveFormPayees(
    String formId,
  ) async {
    final response = await _fbl.post(
      path: 'Payee/getPayeesByFormId',
      body: {'formId': formId},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data =
        ((response.data['list'] ?? []) as List<dynamic>)
            .map((e) {
              return Payees.fromMap(
                e as Map<String, dynamic>,
              );
            })
            .toList();

    if (data.isNotEmpty) {
      storeFormPayees(formId, response);
    }

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

  Future<Response<PayeesResponse>> filterPayees(
    PayeeForm form,
  ) async {
    final response = await _fbl.post(
      path: 'Payee/getAllPayees',
      body: {
        'formId': form.formId,
        'activityId': form.activityId,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = PayeesResponse.fromMap(
      response.data as Map<String, dynamic>,
    );
    if (data.payees?.isNotEmpty ?? false) {
      storePayees(response);
    }

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

  void storePayees(Response<dynamic> response) {
    _db.add(
      key: 'all-payees',
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

  void storeFormPayees(
    String formId,
    Response<dynamic> response,
  ) {
    _db.add(
      key: 'form-payees/$formId',
      payload: {
        'list': response.data['list'],
        'imageBaseUrl': response.imageBaseUrl,
        'imageDirectory': response.imageDirectory,
        'timeStamp': response.timeStamp,
        'code': response.code,
        'status': response.status,
        'message': response.message,
      },
    );
  }

  Future<Response> addPayee({
    required Map<String, dynamic> payload,
    required ProcessRequestModel payment,
  }) async {
    final response = await _fbl.post(
      path: 'Payee/addPayee',
      body: {
        'activityId': payment.activityId,
        'formId': payment.formId,
        'formData': payload,
        'paymentMode': payment.paymentMode,
        "auth": payment.auth.toMap(),
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

  Future<Response> addPayeeAndSchedule({
    required String activityType,
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

  Future<Response> deletePayee(String payeeId) async {
    final response = await _fbl.post(
      path: 'Payee/deletePayee',
      body: {'payeeId': payeeId},
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

  Future<Response> sendPayeeNow({
    required String payeeId,
    required String pin,
  }) async {
    final response = await _fbl.post(
      path: 'Payee/payPayee',
      body: {
        'payeeId': payeeId,
        'auth': {'pin': pin},
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
