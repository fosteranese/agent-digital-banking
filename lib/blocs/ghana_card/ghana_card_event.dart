part of 'ghana_card_bloc.dart';

abstract class GhanaCardEvent extends Equatable {
  const GhanaCardEvent();

  @override
  List<Object> get props => [];
}

// verify ghana card

class VerifyCompleteGhanaCard extends GhanaCardEvent {
  const VerifyCompleteGhanaCard({
    required this.registrationId,
    required this.image,
    required this.code,
  });

  final String registrationId;
  final String image;
  final String code;

  @override
  List<Object> get props => [registrationId, image, code];
}

class ReVerifyCompleteGhanaCard extends GhanaCardEvent {
  const ReVerifyCompleteGhanaCard(this.registrationId);

  final String registrationId;

  @override
  List<Object> get props => [registrationId];
}
