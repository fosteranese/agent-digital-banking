part of 'ghana_card_bloc.dart';

abstract class GhanaCardState extends Equatable {
  const GhanaCardState();

  @override
  List<Object> get props => [];
}

class CompleteGhanaCardInitial extends GhanaCardState {}

// verify ghana card

class VerifyingCompleteGhanaCard extends GhanaCardState {}

class CompleteGhanaCardVerified extends GhanaCardState {
  const CompleteGhanaCardVerified({
    required this.data,
    required this.resendPayload,
  });

  final VerifyGhanaCardResponse data;
  final String resendPayload;

  @override
  List<Object> get props => [
        data,
        resendPayload,
      ];
}

class VerifyCompleteGhanaCardError extends GhanaCardState {
  const VerifyCompleteGhanaCardError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}

class ReVerifyingCompleteGhanaCard extends GhanaCardState {}

class CompleteGhanaCardReVerified extends GhanaCardState {
  const CompleteGhanaCardReVerified({
    required this.data,
    required this.resendPayload,
  });

  final VerifyGhanaCardResponse data;
  final String resendPayload;

  @override
  List<Object> get props => [
        data,
        resendPayload,
      ];
}

class ReVerifyCompleteGhanaCardError extends GhanaCardState {
  const ReVerifyCompleteGhanaCardError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}