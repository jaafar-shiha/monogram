import 'package:monogram/Blocs/FeedBloc/feed_event.dart';
import 'package:monogram/Blocs/FeedBloc/feed_state.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/post_model.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Repository/feed_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/Utils/reactions_type.dart';
import 'package:monogram/Utils/result_classes.dart';
import 'package:monogram/locator.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;

  FeedBloc({required FeedRepository feedRepository})
      : _feedRepository = feedRepository,
        super(const EmptyFeedState()) {
    on<GetPosts>(
      (event, emit) async {
        emit(const LoadingFeedState());
        await _feedRepository.getUserData(userId: event.userId).then((value) {
          if (value is SuccessState<UserModel>) {
            emit(SuccessFeedState(value.data));
          } else if (value is ErrorState<UserModel>) {
            emit(ErrorFeedState(value.error));
          }
        });
      },
    );


    on<GetFriendsData>(
          (event, emit) async {
        emit(const LoadingFeedState());
        await _feedRepository.getFriendsData(usersIds: event.usersIds).then((value) {
          if (value is SuccessState<List<UserModel>>) {
            emit(GettingFriendsDataSucceededState(value.data));
          } else if (value is ErrorState<List<UserModel>>) {
            emit(GettingFriendsDataFailedState(value.error));
          }
        });
      },
    );
    on<ManagePost>(
      (event, emit) async {
        await _feedRepository
            .managePost(
          operationType: event.postOperationType,
          oldPostModel: event.oldPostModel,
          newPostModel: event.newPostModel,
        )
            .then((value) {
          if (value is SuccessState<bool>) {
            emit(ManagePostSucceededState());
          } else if (value is ErrorState<bool>) {
            emit(ManagePostFailedState(value.error));
          }
        });
      },
    );

    on<ManageReactions>(
      (event, emit) async {
        PostModel oldPost = event.postModel;
        PostModel newPost = PostModel(
          userId: oldPost.userId,
          content: oldPost.content,
          dateOfPosting: oldPost.dateOfPosting,
          userName: oldPost.userName,
          userProfilePicture: oldPost.userProfilePicture,
          reactions: oldPost.reactions,
          comments: oldPost.comments,
        );
        switch (event.reactionType) {
          case ReactionsType.like:
            newPost.reactions = newPost.reactions.copyWith(
              likes: newPost.reactions.likes.copyWith(
                count: 1 + newPost.reactions.likes.count,
                usersIds: [
                  locator<MainApp>().user!.id,
                  ...newPost.reactions.likes.usersIds,
                ],
              ),
            );
            break;
          case ReactionsType.unLike:
            newPost = newPost.copyWith(
              reactions: newPost.reactions.copyWith(
                likes: newPost.reactions.likes.copyWith(
                  count: newPost.reactions.likes.count - 1,
                  usersIds: [
                    ...newPost.reactions.likes.usersIds.where((element) => element != locator<MainApp>().user!.id)
                  ],
                ),
              ),
            );
            break;
          default:
            newPost.reactions = newPost.reactions.copyWith(
              likes: newPost.reactions.likes.copyWith(
                count: 1 + newPost.reactions.likes.count,
                usersIds: [
                  locator<MainApp>().user!.id,
                  ...newPost.reactions.likes.usersIds,
                ],
              ),
            );
            break;
        }

        await _feedRepository
            .managePost(
          operationType: OperationType.update,
          oldPostModel: oldPost,
          newPostModel: newPost,
        )
            .then((value) {
          if (value is SuccessState<bool>) {
            emit(ManageReactionsSucceededState());
          } else if (value is ErrorState<bool>) {
            emit(ManageReactionsFailedState(value.error));
          }
        });
      },
    );
    on<ManageComments>(
      (event, emit) async {
        PostModel oldPost = event.postModel;
        PostModel newPost = PostModel(
          userId: oldPost.userId,
          content: oldPost.content,
          dateOfPosting: oldPost.dateOfPosting,
          userName: oldPost.userName,
          userProfilePicture: oldPost.userProfilePicture,
          reactions: oldPost.reactions,
          comments: oldPost.comments
        );
        switch (event.postOperationType) {
          case OperationType.add:
            newPost.comments = [
              event.newComment!,...newPost.comments
            ];
            break;
          case OperationType.update:
            newPost.comments = [
              ...newPost.comments.where((element) => element != event.oldComment),
            ];
            newPost.comments = [
              event.newComment!,...newPost.comments
            ];
            break;
          case OperationType.delete:
            newPost.comments = [
              ...newPost.comments.where((element) => element != event.oldComment),
            ];
            break;
          default:
            newPost.comments = [
              event.newComment!,
              ...newPost.comments,
            ];
            break;
        }
        print('OLD POST MODEL:\n ${oldPost.toMap()}');
        print('NEW POST MODEL:\n ${newPost.toMap()}');
        await _feedRepository
            .managePost(
          operationType: OperationType.update,
          oldPostModel: oldPost,
          newPostModel: newPost,
        )
            .then((value) {
          if (value is SuccessState<bool>) {
            emit(ManageCommentsSucceededState());
          } else if (value is ErrorState<bool>) {
            emit(ManageCommentsFailedState(value.error));
          }
        });
      },
    );
  }
}
