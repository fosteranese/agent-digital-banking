/// Camera exception error codes used by the camera_cameras package
class CameraErrorCodes {
  // Permission/Access errors
  static const String accessDenied = 'CameraAccessDenied';
  static const String accessDeniedWithoutPrompt = 'CameraAccessDeniedWithoutPrompt';
  static const String accessRestricted = 'CameraAccessRestricted';
  
  // Audio errors (when recording video)
  static const String audioAccessDenied = 'AudioAccessDenied';
  static const String audioAccessDeniedWithoutPrompt = 'AudioAccessDeniedWithoutPrompt';
  static const String audioAccessRestricted = 'AudioAccessRestricted';
}
