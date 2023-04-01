import 'package:monogram/Utils/error_model.dart';

abstract class RegisterState<T> {

  factory RegisterState.empty() = EmptyRegisterState<T>;

  factory RegisterState.success(T data) = SuccessRegisterState<T>;

  factory RegisterState.error(ErrorModel error) = ErrorRegisterState<T>;

  factory RegisterState.loading() = LoadingRegisterState<T>;
}

class EmptyRegisterState<T> implements RegisterState<T> {
  const EmptyRegisterState();
}

class LoadingRegisterState<T> implements RegisterState<T> {
  const LoadingRegisterState();
}

class SuccessRegisterState<T> implements RegisterState<T> {
  final T data;

  const SuccessRegisterState(this.data);
}


class ErrorRegisterState<T> implements RegisterState<T> {
  final ErrorModel error;

  ErrorRegisterState(this.error);
}
