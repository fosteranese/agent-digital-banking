import 'dart:convert';

import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/collection/form_verification_response.dart';
import 'package:my_sage_agent/data/models/collection/forms_datum.dart';
import 'package:my_sage_agent/data/models/enquiry.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/process_request.model.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';

class FblOnlineRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<GeneralFlowCategory>?> getStoredCategories(String endpoint) async {
    final result = await _db.read(endpoint);

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = GeneralFlowCategory.fromMap(result['data'] as Map<String, dynamic>);
    return Response(code: result['code'].toString(), status: result['status'].toString(), message: result['message'].toString(), data: data, imageBaseUrl: result['imageBaseUrl']?.toString(), imageDirectory: result['imageDirectory']?.toString(), timeStamp: result['timeStamp']?.toString());
  }

  Future<Response<GeneralFlowCategory>> retrieveCategories(String endpoint) async {
    final response = await _fbl.post(path: endpoint, body: {}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = GeneralFlowCategory.fromMap(response.data as Map<String, dynamic>);

    if (data.forms?.isNotEmpty ?? false) {
      _db.add(key: endpoint, payload: {'data': response.data, 'imageBaseUrl': response.imageBaseUrl, 'imageDirectory': response.imageDirectory, 'timeStamp': response.timeStamp, 'code': response.code, 'status': response.status, 'message': response.message});
    }

    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<GeneralFlowFormData>?> getStoredFormData({required String id, String? qrCode, String? payeeId}) async {
    final qrCodeBase64 = (qrCode?.isNotEmpty ?? false) ? base64.encode(utf8.encode(qrCode!)) : '';
    final result = await _db.read('fbl-online-forms/$id/$qrCodeBase64/$payeeId');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = GeneralFlowFormData.fromMap(result['data'] as Map<String, dynamic>);
    return Response(code: result['code'].toString(), status: result['status'].toString(), message: result['message'].toString(), data: data, imageBaseUrl: result['imageBaseUrl']?.toString(), imageDirectory: result['imageDirectory']?.toString(), timeStamp: result['timeStamp']?.toString());
  }

  Future<Response<GeneralFlowFormData>> retrieveFormData({required String id, String? qrCode, String? payeeId}) async {
    final response = await _fbl.post(path: 'FBLOnline/formDataByFormId', body: {'formId': id, 'qrCode': qrCode, 'payeeId': payeeId}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = GeneralFlowFormData.fromMap(response.data as Map<String, dynamic>);

    if (data.fieldsDatum?.isNotEmpty ?? false) {
      final qrCodeBase64 = (qrCode?.isNotEmpty ?? false) ? base64.encode(utf8.encode(qrCode!)) : '';
      final key = 'fbl-online-forms/$id/$qrCodeBase64/$payeeId';

      _db.add(key: key, payload: {'data': response.data, 'imageBaseUrl': response.imageBaseUrl, 'imageDirectory': response.imageDirectory, 'timeStamp': response.timeStamp, 'code': response.code, 'status': response.status, 'message': response.message});
    }

    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<FormVerificationResponse>> verifyForm({required FormsDatum formData, required Map<String, dynamic> payload}) async {
    final response = await _fbl.post(path: 'FBLCollect/verifyForm', body: {'insId': formData.form?.insId, 'formId': formData.form?.formId, 'formData': payload}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = FormVerificationResponse.fromMap(response.data as Map<String, dynamic>);
    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<FormVerificationResponse>> makePayment({required Map<String, dynamic> payload, required ProcessRequestModel payment}) async {
    final response = await _fbl.post(path: 'FBLCollect/initiatePayment', body: {'activityId': payment.activityId, 'formId': payment.formId, 'formData': payload, 'paymentMode': payment.paymentMode, "auth": payment.auth.toMap()}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = FormVerificationResponse.fromMap(response.data as Map<String, dynamic>);
    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<FormVerificationResponse>> verifyRequest({required GeneralFlowFormData formData, required Map<String, dynamic> payload}) async {
    final response = await _fbl.post(path: 'FBLOnline/verifyForm', body: {'formId': formData.form?.formId, 'formData': payload}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = FormVerificationResponse.fromMap(response.data as Map<String, dynamic>);
    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<RequestResponse>> processRequest({required Map<String, dynamic> payload, required ProcessRequestModel request}) async {
    final response = await _fbl.post(path: 'FBLOnline/processRequest', body: {'activityId': request.activityId, 'formId': request.formId, 'formData': payload, 'paymentMode': request.paymentMode, "auth": request.auth.toMap()}, isAuthenticated: true);

    if (response.status != StatusConstants.success && response.status != StatusConstants.pending && response.status != StatusConstants.processing) {
      return Future.error(response);
    }

    final data = RequestResponse.fromMap(response.data as Map<String, dynamic>);
    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response> saveBeneficiary(RequestResponse payload) async {
    final response = await _fbl.post(path: payload.benficiaryEndpoint ?? '', body: {'receiptId': payload.receiptId}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return Response(code: response.code, message: response.message, status: response.status, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<Enquiry>?> getStoredEnquiry(String endpoint) async {
    final result = await _db.read(endpoint);

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = Enquiry.fromMap(result['data'] as Map<String, dynamic>);
    return Response(code: result['code'].toString(), status: result['status'].toString(), message: result['message'].toString(), data: data, imageBaseUrl: result['imageBaseUrl']?.toString(), imageDirectory: result['imageDirectory']?.toString(), timeStamp: result['timeStamp']?.toString());
  }

  Future<Response<Enquiry>> retrieveEnquiry(String endpoint) async {
    final response = await _fbl.post(path: endpoint, body: {}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = Enquiry.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: endpoint, payload: {'data': response.data, 'imageBaseUrl': response.imageBaseUrl, 'imageDirectory': response.imageDirectory, 'timeStamp': response.timeStamp, 'code': response.code, 'status': response.status, 'message': response.message});

    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<Enquiry>?> getStoredSubEnquiry({required String endpoint, required String formId, required String hashValue}) async {
    final result = await _db.read('$endpoint/$formId/$hashValue');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = Enquiry.fromMap(result['data'] as Map<String, dynamic>);
    return Response(code: result['code'].toString(), status: result['status'].toString(), message: result['message'].toString(), data: data, imageBaseUrl: result['imageBaseUrl']?.toString(), imageDirectory: result['imageDirectory']?.toString(), timeStamp: result['timeStamp']?.toString());
  }

  Future<Response<Enquiry>> retrieveSubEnquiry({required String endpoint, required String formId, required String hashValue}) async {
    final response = await _fbl.post(path: endpoint, body: {'formId': formId, 'hashValue': hashValue}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = Enquiry.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: '$endpoint/$formId/$hashValue', payload: {'data': response.data, 'imageBaseUrl': response.imageBaseUrl, 'imageDirectory': response.imageDirectory, 'timeStamp': response.timeStamp, 'code': response.code, 'status': response.status, 'message': response.message});

    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<GeneralFlowFormData>> prepareScheduler({String? receiptId, String? payeeId}) async {
    final response = await _fbl.post(path: 'Schedule/requestSchedule', body: {'receiptId': receiptId, 'payeeId': payeeId}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = GeneralFlowFormData.fromMap(response.data as Map<String, dynamic>);

    if (data.fieldsDatum?.isNotEmpty ?? false) {
      final key = 'prepare-schedule/$receiptId/$payeeId';

      _db.add(key: key, payload: {'data': response.data, 'imageBaseUrl': response.imageBaseUrl, 'imageDirectory': response.imageDirectory, 'timeStamp': response.timeStamp, 'code': response.code, 'status': response.status, 'message': response.message});
    }

    return Response(code: response.code, message: response.message, status: response.status, data: data, imageBaseUrl: response.imageBaseUrl, imageDirectory: response.imageDirectory, timeStamp: response.timeStamp);
  }

  Future<Response<GeneralFlowFormData>?> getStoredPreparedSchedule({required String? receiptId, required String? payeeId}) async {
    final result = await _db.read('prepare-schedule/$receiptId/$payeeId');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = GeneralFlowFormData.fromMap(result['data'] as Map<String, dynamic>);
    return Response(code: result['code'].toString(), status: result['status'].toString(), message: result['message'].toString(), data: data, imageBaseUrl: result['imageBaseUrl']?.toString(), imageDirectory: result['imageDirectory']?.toString(), timeStamp: result['timeStamp']?.toString());
  }
}
