import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/error_model.dart';

abstract class FeedState {

  factory FeedState.empty() = EmptyFeedState;

  factory FeedState.loading() = LoadingFeedState;

  factory FeedState.success(UserModel user) = SuccessFeedState;

  factory FeedState.error(ErrorModel error) = ErrorFeedState;

  factory FeedState.managePostSucceededState() = ManagePostSucceededState;

  factory FeedState.managePostFailedState(ErrorModel error) = ManagePostFailedState;

  factory FeedState.manageReactionsSucceededState() = ManageReactionsSucceededState;

  factory FeedState.manageReactionsFailedState(ErrorModel error) = ManageReactionsFailedState;

}


class EmptyFeedState<T> implements FeedState {
  const EmptyFeedState();
}

class LoadingFeedState<T> implements FeedState {
  const LoadingFeedState();
}

class SuccessFeedState<T> implements FeedState {
  final UserModel user;

  const SuccessFeedState(this.user);
}

class ErrorFeedState<T> implements FeedState {
  ErrorModel error;

  ErrorFeedState(this.error);
}

class ManagePostSucceededState implements FeedState {
  ManagePostSucceededState();
}

class ManagePostFailedState implements FeedState {
  ErrorModel error;
  ManagePostFailedState(this.error);
}

class ManageReactionsSucceededState implements FeedState {
  ManageReactionsSucceededState();
}

class ManageReactionsFailedState implements FeedState {
  ErrorModel error;
  ManageReactionsFailedState(this.error);
}

class ManageCommentsSucceededState implements FeedState {
  ManageCommentsSucceededState();
}

class ManageCommentsFailedState implements FeedState {
  ErrorModel error;
  ManageCommentsFailedState(this.error);
}

class GettingFriendsDataSucceededState implements FeedState {
  final List<UserModel> friends;
  GettingFriendsDataSucceededState(this.friends);
}

class GettingFriendsDataFailedState implements FeedState {
  ErrorModel error;
  GettingFriendsDataFailedState(this.error);
}