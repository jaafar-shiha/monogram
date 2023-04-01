import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPressed extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  const RegisterPressed(
      {required this.name, required this.email, required this.password,});

  @override
  List<Object> get props => [name, email, password,];

  @override
  String toString() =>
      'RegisterPressed {name: $name, email: $email, password: $password }';
}

class AddProfilePicturePressed extends RegisterEvent {
  final String id;
  final XFile profilePicture;

  const AddProfilePicturePressed(
      {required this.id, required this.profilePicture,});

  @override
  List<Object> get props => [id, profilePicture.name];

}
