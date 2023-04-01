import 'package:monogram/Utils/error_model.dart';

abstract class SignInState<T> {

  factory SignInState.empty() = EmptySignInState<T>;

  factory SignInState.success(T data) = SuccessSignInState<T>;

  factory SignInState.error(ErrorModel error) = ErrorSignInState<T>;

  factory SignInState.googleSignInSucceeded(T data) = SuccessGoogleSignInState<T>;


  factory SignInState.loading() = LoadingSignInState<T>;
}

class EmptySignInState<T> implements SignInState<T> {
  const EmptySignInState();
}

class LoadingSignInState<T> implements SignInState<T> {
  const LoadingSignInState();
}

class SuccessSignInState<T> implements SignInState<T> {
  final T data;

  const SuccessSignInState(this.data);
}

class SuccessGoogleSignInState<T> implements SignInState<T> {
  final T data;

  const SuccessGoogleSignInState(this.data);
}

class ErrorSignInState<T> implements SignInState<T> {
  final ErrorModel error;

  ErrorSignInState(this.error);
}
