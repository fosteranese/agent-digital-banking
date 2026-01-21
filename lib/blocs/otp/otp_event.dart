part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

// retrieve payments

class ResendOtp extends OtpEvent {
  const ResendOtp({required this.uid, required this.formId});

  final String uid;
  final String formId;

  @override
  List<Object> get props => [uid, formId];
}
