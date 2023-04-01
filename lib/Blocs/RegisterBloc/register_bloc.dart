import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monogram/Blocs/RegisterBloc/register_event.dart';
import 'package:monogram/Blocs/RegisterBloc/register_state.dart';
import 'package:monogram/Repository/sign_in_register_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:monogram/Utils/result_classes.dart';
import 'package:stream_transform/stream_transform.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignInRegisterRepository _signInRegisterRepository;

  RegisterBloc({required SignInRegisterRepository signInRegisterRepository})
      : _signInRegisterRepository = signInRegisterRepository,
        super(const EmptyRegisterState()) {

    on<RegisterPressed>(
      (event, emit) async {
        emit(const LoadingRegisterState());
          await _signInRegisterRepository.signUp(
            name: event.name,
            email: event.email,
            password: event.password,
          ).then((value) {
            if (value is SuccessState<UserCredential>){
              emit(SuccessRegisterState(value.data));
            }
            else if (value is ErrorState<UserCredential>){
              emit(ErrorRegisterState(value.error));
            }
          });

      },
      transformer: droppable(),
    );

    on<AddProfilePicturePressed>(
          (event, emit) async {
        emit(const LoadingRegisterState());
        await _signInRegisterRepository.addProfilePictureToUser(id: event.id, profilePicture: event.profilePicture)
          .then((value) {
          if (value is SuccessState<String>){
            emit(SuccessRegisterState(value.data));
          }
          else if (value is ErrorState<String>){
            emit(ErrorRegisterState(value.error));
          }
        });
      },
      transformer: droppable(),
    );
  }

  EventTransformer<Event> debounce<Event>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }
}

