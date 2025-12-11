import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/general_flow/general_flow_bloc.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/data/models/user_response/scan_to_pay.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/qr_code.page.dart';

class QrCodeUtil {
  static void openScanToPay({required ScanToPay scanToPay, required String iconBaseUrl}) {
    final item = scanToPay.activityItems!.first;
    showQrCodeScanner(title: item.formName ?? '', formId: item.formId ?? '', icon: '$iconBaseUrl/${item.icon}');
  }

  static void showQrCodeScanner({required String title, required String formId, required String icon}) {
    Navigator.push(
      MyApp.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => QrCodePage(
          title: title,
          icon: icon,
          onSuccess: (String qrCode) {
            Navigator.pop(context);
            context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowFormData(formId: formId, routeName: DashboardPage.routeName, activityType: ActivityTypesConst.fblOnline, qrCode: qrCode));
          },
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    context.pop();
  }
}
