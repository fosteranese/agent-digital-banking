// import 'dart:convert';

import 'package:my_sage_agent/constants/field.const.dart';
import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/collection/form_verification_response.dart';
import 'package:my_sage_agent/data/models/collection/forms_datum.dart';
import 'package:my_sage_agent/data/models/collection/institution_data.dart';
import 'package:my_sage_agent/data/models/collection/institution_form_data.dart';
import 'package:my_sage_agent/data/models/collection/lov.dart';
import 'package:my_sage_agent/data/models/collection/payment.dart';
import 'package:my_sage_agent/data/models/collection/payment_categories.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_field.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/process_request.model.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';
import 'package:my_sage_agent/utils/app.util.dart';

class PaymentRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<List<Payment>>?> getStoredPayments() async {
    final result = await _db.read('payments');

    if (result == null || result['list'] == null) {
      return null;
    }

    final List<Payment> list = result['list'] != null
        ? (result['list'] as List<dynamic>).map((e) => Payment.fromMap(e)).toList()
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

  Future<Response<List<Payment>>> retrievePayments() async {
    final response = await _fbl.post(
      path: 'FBLCollect/categories',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final List<Payment> list = response.data['list'] != null
        ? (response.data['list'] as List<dynamic>).map((e) => Payment.fromMap(e)).toList()
        : [];

    if (list.isNotEmpty) {
      _db.add(
        key: 'payments',
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

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: list,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<PaymentCategories>?> getStoredPaymentCategories(String id) async {
    final result = await _db.read('payment-categories/$id');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = PaymentCategories.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<PaymentCategories>> retrievePaymentCategories(String id) async {
    final response = await _fbl.post(
      path: 'FBLCollect/categories/$id',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = PaymentCategories.fromMap(response.data as Map<String, dynamic>);

    if (data.institution?.isNotEmpty ?? false) {
      _db.add(
        key: 'payment-categories/$id',
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

  Future<Response<PaymentCategories>?> getStoredPaymentCategoriesWithEndpoint(
    String endpoint,
  ) async {
    final result = await _db.read(endpoint);

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = PaymentCategories.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<PaymentCategories>> retrievePaymentCategoriesWithEndpoint(String endpoint) async {
    final response = await _fbl.post(path: endpoint, body: {}, isAuthenticated: true);

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = PaymentCategories.fromMap(response.data as Map<String, dynamic>);

    if (data.institution?.isNotEmpty ?? false) {
      _db.add(
        key: endpoint,
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

  Future<Response<InstitutionFormData>?> getStoredInstitutionFormData(String id) async {
    final result = await _db.read('institution-forms/$id');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = InstitutionFormData.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<GeneralFlowFormData>?> getStoredInstitutionFormData1(String id) async {
    final result = await _db.read('institution-forms-1/$id');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = GeneralFlowFormData.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<InstitutionFormData>> retrieveInstitutionFormData(String id) async {
    final response = await _fbl.post(
      path: 'FBLCollect/formsDataByInsId',
      body: {'insId': id},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = InstitutionFormData.fromMap(response.data as Map<String, dynamic>);

    if (data.institutionData?.formsData?.isNotEmpty ?? false) {
      _db.add(
        key: 'institution-forms/$id',
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

  Future<Response<GeneralFlowFormData>> retrieveInstitutionFormData1({
    required String institutionId,
    required ActivityDatum activity,
  }) async {
    final response = await _fbl.post(
      path: 'FBLCollect/formsDataByInsId',
      body: {'insId': institutionId},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final rawData = InstitutionFormData.fromMap(response.data as Map<String, dynamic>);
    final institution = rawData.institutionData!.institution!;
    final formData = rawData.institutionData!.formsData!.first;

    final paymentSources =
        rawData.sourceOfPayment
            ?.map((item) {
              return item.sources?.map((sub) {
                    return Lov(lovTitle: sub.tile, lovValue: sub.value);
                  }).toList() ??
                  [];
            })
            .expand((item) => item)
            .toList() ??
        [];

    final data = GeneralFlowFormData(
      authMode: formData.authMode,
      institution: institution,
      form: GeneralFlowForm(
        categoryId: institution.catId,
        requireVerification: formData.form!.requireVerification,
        description: institution.description,
        icon: institution.icon,
        formId: formData.form!.formId,
        formName: formData.form!.formName,
        tooltip: formData.form!.tooltip,
        caption: formData.form!.caption,
        activityType: activity.activity!.activityType,
        accessType: '',
        allowBeneficiary: 1,
        allowSchedule: 1,
        createdBy: formData.phoneNumber,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        iconType: institution.icon,
        internalEndpoint: '',
        modifiedBy: formData.phoneNumber,
        processEndpoint: formData.form!.processEndpoint,
        rank: formData.form!.rank,
        showInFavourite: 1,
        showInHistory: 1,
        showReceipt: 1,
        status: 1,
        statusLabel: 'success',
        verifyEndpoint: formData.form!.verifyEndpoint,
      ),
      fieldsDatum:
          formData.fieldsData!.map((item) {
            return GeneralFlowFieldsDatum(
              field: GeneralFlowField(
                createdBy: 'user',
                dateCreated: DateTime.now(),
                dateModified: DateTime.now(),
                defaultValue: item.field!.defaultValue,
                fieldCaption: item.field!.caption,
                fieldDataType: item.field!.fieldDataType,
                fieldDateFormat: item.field!.fieldDateFormat,
                fieldId: item.field!.fieldId,
                fieldInRemarks: item.field!.fieldInRemarks,
                fieldLength: item.field!.fieldLength,
                fieldMandatory: item.field!.fieldMandatory,
                fieldName: item.field!.fieldName,
                fieldType: item.field!.fieldType,
                fieldVisible: item.field!.fieldVisible,
                formId: item.field!.formId,
                isAmount: item.field!.isAmount,
                lovEndpoint: item.field!.lovEndpoint,
                modifiedBy: 'user',
                rank: item.field!.rank,
                readOnly: item.field!.readOnly,
                requiredForVerification: item.field!.requireVerification,
                showOnReceipt: item.field!.showOnReceipt,
                status: 1,
                statusLabel: 'success',
                thirdParty: 1,
                toolTip: item.field!.tooltip,
              ),
              lov: item.lov,
            );
          }).toList()..add(
            GeneralFlowFieldsDatum(
              lov: paymentSources,
              field: GeneralFlowField(
                formId: formData.form!.formId,
                fieldId: 'SourceAccount',
                fieldName: 'SourceAccount',
                fieldCaption: 'Payment Source',
                defaultValue: '',
                fieldDataType: FieldDataTypesConst.sourceAccount,
                fieldMandatory: 1,
                fieldType: FieldTypesConst.listOfValues,
                fieldVisible: 1,
                readOnly: 0,
                requiredForVerification: 1,
                isAmount: 0,
                showOnReceipt: 1,
                rank: formData.fieldsData!.length,
                toolTip: 'Select your preferred payment option',
              ),
            ),
          ),
    );

    if (rawData.institutionData?.formsData?.isNotEmpty ?? false) {
      _db.add(
        key: 'institution-forms/$institutionId',
        payload: {
          'data': data.toMap(),
          'imageBaseUrl': response.imageBaseUrl,
          'imageDirectory': response.imageDirectory,
          'timeStamp': response.timeStamp,
          'code': response.code,
          'status': response.status,
          'message': response.message,
        },
      );
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

  Future<Response<FormVerificationResponse>> verifyForm({
    required GeneralFlowFormData formData,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _fbl.post(
      path: 'FBLCollect/verifyForm',
      body: {
        'insId': formData.institution?.insId,
        'formId': formData.form?.formId,
        'formData': payload,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = FormVerificationResponse.fromMap(response.data as Map<String, dynamic>);
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

  Future<Response<RequestResponse>> makePayment({
    required Map<String, dynamic> payload,
    required ProcessRequestModel payment,
  }) async {
    final response = await _fbl.post(
      path: 'FBLCollect/initiatePayment',
      body: {
        'activityId': payment.activityId,
        'formId': payment.formId,
        'formData': payload,
        'paymentMode': payment.paymentMode,
        "auth": payment.auth.toMap(),
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success &&
        response.status != StatusConstants.pending &&
        response.status != StatusConstants.processing) {
      return Future.error(response);
    }

    final data = RequestResponse.fromMap(response.data as Map<String, dynamic>);
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

  Future<Response> saveBeneficiary(RequestResponse payload) async {
    final response = await _fbl.post(
      path: payload.benficiaryEndpoint ?? '',
      body: {'receiptId': payload.receiptId},
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

  Future<Response<InstitutionFormData>> retrieveFormData({
    required String activityId,
    required String formId,
    String? payeeId,
  }) async {
    final response = await _fbl.post(
      path: 'FBLCollect/formDataByFormId',
      body: {'activityId': activityId, 'formId': formId, 'payeeId': payeeId},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final formsData = FormsDatum.fromMap(response.data['forms'] as Map<String, dynamic>);
    if (formsData.fieldsData?.isNotEmpty ?? false) {
      _db.add(
        key: 'collection-forms/$activityId/$formId/$payeeId',
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

    String institutionId = response.data['institution']['insId'];
    final result2 = await retrieveInstitutionFormData(institutionId);

    final data = InstitutionFormData(
      institutionData: InstitutionData(
        formsData: List.filled(1, formsData),
        institution: result2.data!.institutionData!.institution!,
      ),
      sourceOfPayment: result2.data?.sourceOfPayment ?? [],
    );

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

  Future<Response<GeneralFlowFormData>> retrieveFormData1({
    required String activityType,
    required String formId,
    String? payeeId,
  }) async {
    final activity = AppUtil.currentUser.activities!.firstWhere(
      (item) => item.activity!.activityType == activityType,
    );

    final response = await _fbl.post(
      path: 'FBLCollect/formDataByFormId',
      body: {'activityId': activity.activity!.activityId, 'formId': formId, 'payeeId': payeeId},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    String institutionId = response.data['institution']['insId'];

    _db.add(
      key: 'collection-forms/${activity.activity!.activityId}/$formId/$payeeId',
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

    return await retrieveInstitutionFormData1(institutionId: institutionId, activity: activity);
  }

  Future<Response<InstitutionFormData>?> getStoredCollectionForm({
    required String activityId,
    required String formId,
    String? payeeId,
  }) async {
    final result = await _db.read('collection-forms/$activityId/$formId/$payeeId');
    if (result == null || result['data'] == null) {
      return null;
    }
    final formsData = FormsDatum.fromMap(result['data']['forms'] as Map<String, dynamic>);
    if (result['data']['institution'] == null || result['data']['institution']['insId'] == null) {
      return null;
    }

    String institutionId = result['data']['institution']['insId'];
    var result2 = await getStoredInstitutionFormData(institutionId);
    result2 ??= await retrieveInstitutionFormData(institutionId);

    final data = InstitutionFormData(
      institutionData: InstitutionData(
        formsData: List.filled(1, formsData),
        institution: result2.data!.institutionData!.institution!,
      ),
      sourceOfPayment: result2.data?.sourceOfPayment ?? [],
    );

    return Response(
      code: result['code'],
      message: result['message'],
      status: result['status'],
      data: data,
      imageBaseUrl: result['imageBaseUrl'],
      imageDirectory: result['imageDirectory'],
      timeStamp: result['timeStamp'],
    );
  }

  Future<Response<GeneralFlowFormData>?> getStoredCollectionForm1({
    required String activityType,
    required String formId,
    String? payeeId,
  }) async {
    final activity = AppUtil.currentUser.activities!.firstWhere(
      (item) => item.activity!.activityType == activityType,
    );

    final result = await _db.read(
      'collection-forms/${activity.activity!.activityId}/$formId/$payeeId',
    );

    if (result?['data']?['institution']?['insId'] == null) {
      return null;
    }

    String institutionId = result!['data']['institution']['insId'];

    return await getStoredInstitutionFormData1(institutionId);
  }
}
