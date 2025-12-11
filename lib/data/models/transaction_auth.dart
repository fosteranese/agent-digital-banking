class TransactionAuth {
  const TransactionAuth({
    this.pin,
    this.secretAnswer,
    this.otp,
  });

  final String? pin;
  final String? secretAnswer;
  final String? otp;

  Map<String, dynamic> toMap() => {
        'pin': pin,
        'secretAnswer': secretAnswer,
        'otp': otp,
      };
}