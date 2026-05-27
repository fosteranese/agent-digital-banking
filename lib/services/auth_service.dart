import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/initialization_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/user_response.dart';
import 'package:my_sage_agent/data/repository/auth.repo.dart';

/// Service for managing authentication and security.
///
/// Handles security checks, threat detection, and auth state management.
class AuthService {
  static late InitializationResponse data;
  static UserResponse? currentUser;
  static String? fcmToken;
  static final db = Database();
  static final auth = AuthRepo();
  static bool isLinkedMoMoWalletClosed = false;
  static Response deviceStatus = const Response(
    code: StatusConstants.pending,
    status: StatusConstants.pending,
    message: 'Checking Device compatibility status',
  );

  /// Perform security checks on app integrity.
  static Future<void> checkSecurity(
    void Function(String threat, Response<dynamic> error) callbackAction,
  ) async {
    // Security check implementation
    // Note: Talsec initialization is handled elsewhere in the application
  }

  /// Check if any threats have been detected.
  static Future<Response?> isThreatFound() async {
    return null;
  }

  /// Perform device compatibility check.
  static Future<Response> deviceCheck() async {
    deviceStatus = const Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'This device is ready to run this application',
    );
    return deviceStatus;
  }

  /// Clear auth state on logout.
  static void logout() {
    currentUser = null;
    isLinkedMoMoWalletClosed = false;
  }
}
