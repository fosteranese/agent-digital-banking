part of 'minimal_bloc.dart';

abstract class MinimalState extends Equatable {
  const MinimalState();

  @override
  List<Object> get props => [];
}

class AppModeInitial extends MinimalState {}

//
// start new session

class StartingNewSession extends MinimalState {
  const StartingNewSession();

  @override
  List<Object> get props => [];
}

class NewSessionStarted extends MinimalState {
  const NewSessionStarted(this.result);

  final Response<MinimalResponse> result;

  @override
  List<Object> get props => [result];
}

class StartSessionError extends MinimalState {
  const StartSessionError(this.result);

  final Response result;

  @override
  List<Object> get props => [result];
}

//
// rely session

class ReplyingSession extends MinimalState {
  const ReplyingSession({required this.id, required this.reply});

  final String id;
  final String reply;

  @override
  List<Object> get props => [id, reply];
}

class SessionReplied extends MinimalState {
  const SessionReplied({required this.id, required this.result});

  final String id;
  final Response<MinimalResponse> result;

  @override
  List<Object> get props => [id, result];
}

class ReplySessionError extends MinimalState {
  const ReplySessionError({required this.id, required this.result});

  final String id;
  final Response result;

  @override
  List<Object> get props => [id, result];
}
