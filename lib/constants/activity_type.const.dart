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
  static const cashAtHand = FormType(id: 'cash-at-hand', name: 'Cash At hand');
  static const deposit = FormType(id: 'deposit', name: 'Deposit');
  static const cash = FormType(id: 'cash', name: 'Cash');
  static const mobileMoney = FormType(id: 'momo', name: 'MoMo');
}

class FormType {
  const FormType({required this.id, required this.name});

  final String id;
  final String name;
}

enum AmDoing {
  transaction,
  addPayee,
  payeeTransaction,
  createBulkPaymentGroup,
  createSchedule,
  createScheduleFromPayee,
}
