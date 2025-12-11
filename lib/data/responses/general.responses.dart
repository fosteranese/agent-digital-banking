import '../models/response.modal.dart';

class GeneralResponse {
  static const Response offline = Response(
    code: 'unavailable_network',
    status: 'error',
    message: 'It looks like you\'re offline. Please check your internet connection and try again. If the issue persists, please close and relaunch the app.',
  );
  static const Response unknown = Response(
    code: 'UNKNOWN',
    status: 'error',
    message: 'We couldn\'t process your request at this time. Please attempt it again',
  );
  static const Response forceUpdate = Response(
    code: '9000',
    status: 'error',
    message: 'A new version is available. Please update to the latest version to continue using the app',
  );
}