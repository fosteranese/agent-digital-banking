import '../../constants/status.const.dart';
import '../remote/main.remote.dart';

class CustomizeRepo {
  final _fbl = MainRemote();

  Future<bool> toggleShowOnDashboard({
    required String activityId,
    required bool status,
  }) async {
    final response = await _fbl.post(
      path: 'MyAccount/modifyActivityDashboard',
      body: {
        'activityId': activityId,
        'status': !status ? 1 : 0,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return !status;
  }
}