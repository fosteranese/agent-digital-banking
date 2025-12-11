part of 'minimal_bloc.dart';

abstract class MinimalEvent extends Equatable {
  const MinimalEvent();

  @override
  List<Object> get props => [];
}

class StartNewSession extends MinimalEvent {
  const StartNewSession();

  @override
  List<Object> get props => [];
}

class SendReplySession extends MinimalEvent {
  const SendReplySession({
    required this.id,
    required this.reply,
    required this.session,
  });

  final String id;
  final String reply;
  final MinimalResponse session;

  @override
  List<Object> get props => [
        id,
        reply,
        session,
      ];
}