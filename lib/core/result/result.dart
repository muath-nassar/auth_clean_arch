import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// This class is designed to deliver the presentation layer with an
/// object, meanwhile preventing exception handling to be part of the top layers
class Result<T> extends Equatable{
  final T? data;
  final Failure? failure;

  const Result._({this.data, this.failure});

  factory Result.success(T data){
    return Result._(data: data);
  }

  factory Result.failure(Failure failure){
    return Result._(failure: failure);
  }

bool isSuccess() => data != null;

  @override
  List<Object?> get props => [data, failure];

}