import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/response.modal.dart';

class AppModeRepo {
  final _db = Database();

  Future<Response<bool>> getAppModeSettings() async {
    final result = await _db.read('app-mode');

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'App mode retrieved',
      data: (result != null && result['isMinimal'] != null) ? result['isMinimal'] as bool : false,
    );
  }

  Future<Response<bool>> changeAppMode(bool status) async {
    await _db.add(key: 'app-mode', payload: {
      'isMinimal': status,
    });

    return Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'App mode changed',
      data: status,
    );
  }
}