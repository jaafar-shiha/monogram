import 'package:monogram/Utils/error_model.dart';

abstract class ResponseState<T> {
  factory ResponseState.empty() = EmptyState<T>;

  factory ResponseState.success(T data) = SuccessState<T>;

  factory ResponseState.error(ErrorModel error) = ErrorState<T>;

  factory ResponseState.loading() = LoadingState<T>;
}

class SuccessState<T> implements ResponseState<T> {
  final T data;

  const SuccessState(this.data);
}

class ErrorState<T> implements ResponseState<T> {
  final ErrorModel error;

  ErrorState(this.error);
}

class LoadingState<T> implements ResponseState<T> {
  const LoadingState();
}

class EmptyState<T> implements ResponseState<T> {
  const EmptyState();
}
