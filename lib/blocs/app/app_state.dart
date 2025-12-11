part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class CheckingDeviceStatus extends AppState {}

class NewDevice extends AppState {}

class ExistingDevice extends AppState {}

class UserExistOnDevice extends AppState {}

class AppError extends AppState {
  const AppError(this.result);

  final Response<dynamic> result;
}