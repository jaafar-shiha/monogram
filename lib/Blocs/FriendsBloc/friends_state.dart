import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/error_model.dart';

abstract class FriendsState{}


class EmptyFriendsState implements FriendsState {
  EmptyFriendsState();
}



class SuccessFriendsState<T> implements FriendsState {
  final List<UserModel> friends;

  const SuccessFriendsState(this.friends);
}

class ErrorFriendsState<T> implements FriendsState {
  ErrorModel error;

  ErrorFriendsState(this.error);
}


class LoadingManagingFriendshipState implements FriendsState {

  const LoadingManagingFriendshipState();
}

class SuccessManagingFriendshipState implements FriendsState {

  const SuccessManagingFriendshipState();
}

class ErrorManagingFriendshipState implements FriendsState {
  ErrorModel error;

  ErrorManagingFriendshipState(this.error);
}
