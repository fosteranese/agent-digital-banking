import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/response.modal.dart';

class BiometricRepo {
  final _db = Database();

  Future<Response<Map<String, bool>>> getBiometricSettings() async {
    final result = await Future.wait([
      _db.read('biometric-login'),
      _db.read('biometric-auto-login'),
      _db.read('biometric-transaction'),
      _db.read('biometric-auto-transaction'),
    ]);

    final data = result.map((e) {
      if (e != null) {
        return e['status'] as bool;
      }

      return false;
    }).toList();

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'Biometric settings retrieved',
      data: {
        'biometric-login': data[0],
        'biometric-auto-login': data[1],
        'biometric-transaction': data[2],
        'biometric-auto-transaction': data[3],
      },
    );
  }

  Future<Response<bool>> changeBiometricLoginStatus(bool status) async {
    await _db.add(key: 'biometric-login', payload: {'status': status});

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'Biometric login change',
      data: status,
    );
  }

  Future<Response<bool>> changeAutoBiometricLoginStatus(bool status) async {
    await _db.add(key: 'biometric-auto-login', payload: {'status': status});

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'Biometric auto login change',
      data: status,
    );
  }

  Future<Response<bool>> changeBiometricTransactionStatus(bool status) async {
    await _db.add(key: 'biometric-transaction', payload: {'status': status});

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'Biometric transaction change',
      data: status,
    );
  }

  Future<Response<bool>> changeAutoBiometricTransactionStatus(bool status) async {
    await _db.add(key: 'biometric-auto-transaction', payload: {'status': status});

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'Biometric auto transaction change',
      data: status,
    );
  }
}
