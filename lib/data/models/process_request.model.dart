import 'transaction_auth.dart';

class ProcessRequestModel {
  const ProcessRequestModel({
    required this.activityId,
    required this.formId,
    required this.paymentMode,
    required this.auth,
  });

  final String activityId;
  final String formId;
  final String paymentMode;
  final TransactionAuth auth;
}