import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGooglePressed extends SignInEvent {}

class SignInWithCredentialsPressed extends SignInEvent {
  final String email;
  final String password;

  const SignInWithCredentialsPressed(
      {required this.email, required this.password});

  @override
  List<Object> get props => [email, password];

}
