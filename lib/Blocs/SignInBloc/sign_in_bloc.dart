import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_event.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_state.dart';
import 'package:monogram/Repository/sign_in_register_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:monogram/Utils/result_classes.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRegisterRepository _signInRegisterRepository;

  SignInBloc({required SignInRegisterRepository signInRegisterRepository})
      : _signInRegisterRepository = signInRegisterRepository,
        super(SignInState.empty()) {
    on<SignInWithGooglePressed>(
      (event, emit) async {
        emit(const LoadingSignInState());
        await _signInRegisterRepository.signInWithGoogle().then((value) {
          if (value is SuccessState<UserCredential>) {
            emit(SuccessGoogleSignInState<UserCredential>(value.data));
          } else if (value is ErrorState<UserCredential>) {
            emit(ErrorSignInState<UserCredential>(value.error));
          }
        });
      },
    );
    on<SignInWithCredentialsPressed>(
      (event, emit) async {
        emit(const LoadingSignInState());
        await _signInRegisterRepository
            .signInWithCredentials(
          email: event.email,
          password: event.password,
        )
            .then((value) {
          if (value is SuccessState<UserCredential>) {
            emit(SuccessSignInState<UserCredential>(value.data));
          } else if (value is ErrorState<UserCredential>) {
            emit(ErrorSignInState<UserCredential>(value.error));
          }
        });
      },
      transformer: droppable(),
    );
  }
}
