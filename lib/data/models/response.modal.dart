import 'package:equatable/equatable.dart';

class Response<T> extends Equatable {
  const Response({
    required this.code,
    required this.status,
    required this.message,
    this.timeStamp,
    this.imageBaseUrl,
    this.imageDirectory,
    this.data,
  });

  final String code;
  final String status;
  final String message;
  final String? timeStamp;
  final String? imageBaseUrl;
  final String? imageDirectory;
  final T? data;

  Response<T> copyWith({
    String? code,
    String? status,
    String? message,
    String? timeStamp,
    String? imageBaseUrl,
    String? imageDirectory,
    T? data,
  }) =>
      Response(
        code: code ?? this.code,
        status: status ?? this.status,
        message: message ?? this.message,
        timeStamp: timeStamp ?? this.timeStamp,
        imageBaseUrl: imageBaseUrl ?? this.imageBaseUrl,
        imageDirectory: imageDirectory ?? this.imageDirectory,
        data: data ?? this.data,
      );

  @override
  List<Object?> get props => [
        code,
        status,
        message,
        timeStamp,
        imageBaseUrl,
        imageDirectory,
        data,
      ];
}