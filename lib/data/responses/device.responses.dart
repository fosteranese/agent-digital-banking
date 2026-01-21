import '../models/response.modal.dart';

class DeviceResponse {
  static const Response locationDenied = Response<String>(
    code: 'LOCATION_DENIED',
    status: 'FAILED',
    message: 'We current do not have permission to your device',
    data: 'Grant Permission',
  );

  static const Response locationDisabled = Response<String>(
    code: 'LOCATION_DISABLED',
    status: 'FAILED',
    message: 'You have disabled GPS Location on your device',
    data: 'Enable GPS Location',
  );
}
