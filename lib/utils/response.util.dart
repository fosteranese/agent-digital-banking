import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../constants/status.const.dart';
import '../data/models/response.modal.dart';
import '../data/responses/general.responses.dart';
import '../logger.dart';
import '../main.dart';
import 'app.util.dart';

class ResponseUtil {
  static String convertFromStatusCode(int code) {
    switch (code) {
      case 1:
        return StatusConstants.success;
      case 0:
      case 2:
      case 100:
        return StatusConstants.failed;
      case 3:
        return StatusConstants.pending;
      case 5:
        return StatusConstants.processing;
      default:
        return StatusConstants.error;
    }
  }

  static int convertToStatusCode(String code) {
    switch (code) {
      case StatusConstants.success:
        return 1;
      case StatusConstants.failed:
        return 2;
      case StatusConstants.pending:
        return 3;
      case StatusConstants.processing:
        return 3;
      default:
        return -1;
    }
  }

  static void handleException(dynamic exception, emit) {
    logger.e(exception);

    if (exception is Response) {
      if (exception.code == '1000') {
        BlocProvider.of<AuthBloc>(
          MyApp.navigatorKey.currentContext!,
        ).add(const Logout());
        return;
      } else if (exception.code == '9000') {
        AppUtil.forceUpdate(exception);
        return;
      }

      emit(exception);
      return;
    } else if (exception is Response<dynamic>) {
      if (exception.code == '1000') {
        BlocProvider.of<AuthBloc>(
          MyApp.navigatorKey.currentContext!,
        ).add(const Logout());
        return;
      }

      emit(exception);
      return;
    }

    emit(GeneralResponse.unknown);
  }
}
