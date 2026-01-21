part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

// retrieve accounts

class ResendingOtp extends OtpState {
  const ResendingOtp(this.uid);
  final String uid;

  @override
  List<Object> get props => [uid];
}

class OtpResent extends OtpState {
  const OtpResent({required this.result, required this.uid});
  final Response<dynamic> result;
  final String uid;
  @override
  List<Object> get props => [result, uid];
}

class ResendOtpError extends OtpState {
  const ResendOtpError({required this.result, required this.uid});

  final Response<dynamic> result;
  final String uid;

  @override
  List<Object> get props => [result, uid];
}
