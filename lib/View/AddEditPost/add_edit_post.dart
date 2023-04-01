import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Blocs/FeedBloc/feed_bloc.dart';
import 'package:monogram/Blocs/FeedBloc/feed_event.dart';
import 'package:monogram/Blocs/FeedBloc/feed_state.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/Reactions/likes.dart';
import 'package:monogram/Models/Reactions/reactions.dart';
import 'package:monogram/Models/post_model.dart';
import 'package:monogram/Models/user_model.dart';

import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/SharedWidgets/main_scaffold.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class AddEditPost extends StatefulWidget {
  final PostModel? postModel;

  const AddEditPost({Key? key, this.postModel}) : super(key: key);

  @override
  _AddEditPostState createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  late final FeedBloc _feedBloc = BlocProvider.of<FeedBloc>(context);

  late TextEditingController content = TextEditingController(text: widget.postModel?.content ?? '');

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _feedBloc,
      listener: (context, state) {
        isLoading.value = false;
        if (state is ManagePostSucceededState) {
        } else if (state is ManagePostFailedState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: state.error.message));

          Navigator.pop(context);
        }
      },
      listenWhen: (previous, current) {
        return previous != current;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, _) {
          return ModalProgressHUD(
            inAsyncCall: isLoading.value,
            child: MainScaffold(
              appBarTitle: widget.postModel != null ? S.of(context).editPost : S.of(context).addPost,
              appBarLeading: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).discard,
                  style: AppStyles.h3,
                ),
              ),
              appBarLeadingWidth: 80,
              appBarActions: [
                TextButton(
                  onPressed: () {
                    UserModel currentUser = locator<MainApp>().user!;
                    isLoading.value = true;
                    _feedBloc.add(
                      widget.postModel != null
                          ? ManagePost(
                              postOperationType: OperationType.update,
                              oldPostModel: widget.postModel,
                              newPostModel: PostModel(
                                  userId: currentUser.id,
                                  userName: currentUser.name,
                                  userProfilePicture: currentUser.profilePictureUrl,
                                  dateOfPosting: DateTime.now(),
                                  reactions: widget.postModel!.reactions,
                                  content: content.text),
                            )
                          : ManagePost(
                              postOperationType: OperationType.add,
                              newPostModel: PostModel(
                                  userId: currentUser.id,
                                  userName: currentUser.name,
                                  userProfilePicture: currentUser.profilePictureUrl,
                                  reactions: widget.postModel?.reactions ??
                                      Reactions(
                                        likes: Likes(count: 0, usersIds: []),
                                      ),
                                  dateOfPosting: DateTime.now(),
                                  content: content.text),
                            ),
                    );
                  },
                  child: Text(
                    widget.postModel != null ? S.of(context).edit : S.of(context).post,
                    style: AppStyles.h3,
                  ),
                ),
              ],
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                      child: TextFormField(
                        maxLines: null,
                        expands: true,
                        style: AppStyles.h2,
                        controller: content,
                        decoration: InputDecoration(
                          hintText: S.of(context).whatDoYouWantToShare,
                          hintStyle: AppStyles.h2.copyWith(color: AppColors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
