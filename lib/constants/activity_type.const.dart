class ActivityTypesConst {
  static const fblCollect = 'FBLCOLLECT';
  static const fblOnline = 'FBLONLINE';
  static const quickFlowAlt = 'QUCKFLOW';
  static const quickFlow = 'QUICKFLOW';
  static const fblonlineCategory = 'FBLONLINE_CATEGORY';
  static const fblCollectCategory = 'FBLCOLLECT_CATEGORY';
  static const quickFlowCategory = 'QUICKFLOW_CATEGORY';
  static const enquiry = 'ENQUIRY';
  static const statement = 'STATEMENT';
  static const scanToPay = 'SCANTOPAY';
  static const history = 'HISTORY';
  static const bulkPayment = 'BULKPAYMENT';
  static const schedule = 'SCHEDULE';
}

class FormsConst {
  static const cashDeposit = FormType(id: '4495b4cf-b688-499a-9d43-fbfac3cfa58d', name: 'Cash');
  static const mobileMoney = FormType(id: '95448ead-9bf2-48fd-a215-e36602cd018c', name: 'MoMo');
}

class FormType {
  const FormType({required this.id, required this.name});

  final String id;
  final String name;
}
