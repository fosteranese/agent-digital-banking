import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/account_opening_lovs.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class SetupRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<AccountOpeningLovs>?> getStoredRetrieveAccountOpeningLOVs() async {
    final result = await _db.read('account-opening-lovs');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = AccountOpeningLovs.fromMap(result['data'] as Map<String, dynamic>);
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

  Future<Response<AccountOpeningLovs>> retrieveAccountOpeningLOVs() async {
    final response = await _fbl.post(
      path: 'UserAccess/accountOpeningLov',
      body: {},
      isAuthenticated: false,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = AccountOpeningLovs.fromMap(response.data as Map<String, dynamic>);
    _db.add(
      key: 'account-opening-lovs',
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
