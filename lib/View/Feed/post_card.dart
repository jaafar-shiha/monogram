import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monogram/Blocs/FeedBloc/feed_bloc.dart';
import 'package:monogram/Blocs/FeedBloc/feed_event.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/Reactions/likes.dart';
import 'package:monogram/Models/Reactions/reactions.dart';
import 'package:monogram/Models/post_model.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/Utils/reactions_type.dart';
import 'package:monogram/View/AddEditPost/add_edit_post.dart';
import 'package:monogram/View/Feed/Comments/comments_page.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class PostCard extends StatefulWidget {
  final PostModel postModel;
  final Function onDelete;

  const PostCard({Key? key, required this.postModel, required this.onDelete}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Map<String, VoidCallback> menuChoices = {};

  @override
  void initState() {
    initMenu();
    super.initState();
  }

  void initMenu() {
    menuChoices.putIfAbsent(
        S().edit,
        () => () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditPost(
                            postModel: widget.postModel,
                          )));
            });
    menuChoices.putIfAbsent(
        S().delete,
        () => () {
              widget.onDelete();
            });
  }

  void handleClick(String value) {
    menuChoices[value]!.call();
  }

  late UserModel user = locator<MainApp>().user!;

  late ValueNotifier<bool> isCurrentUserLikedThisPost =
      ValueNotifier(widget.postModel.reactions.likes.usersIds.contains(user.id));

  late final FeedBloc _feedBloc = BlocProvider.of<FeedBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _feedBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        backgroundImage: widget.postModel.userProfilePicture != null
                            ? NetworkImage(
                                widget.postModel.userProfilePicture!,
                              )
                            : const AssetImage(
                                'assets/images/no_profile_picture.png',
                              ) as ImageProvider,
                      ),
                    ),
                    title: Text(
                      widget.postModel.userName,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${S.of(context).postedOn} ${widget.postModel.dateOfPosting}',
                      style: AppStyles.h4,
                    ),
                    trailing: widget.postModel.userId == locator<MainApp>().user!.id ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_outlined),
                      onSelected: handleClick,
                      itemBuilder: (context) {
                        return menuChoices.keys.map((choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.postModel.content,
                          style: AppStyles.h3,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isCurrentUserLikedThisPost,
                      builder: (context, _, __) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent,
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    isCurrentUserLikedThisPost.value ? Colors.grey.shade500 : Colors.grey.shade300,
                                  ),
                                ),
                                onPressed: () {
                                  _feedBloc.add(
                                    ManageReactions(
                                        reactionType: isCurrentUserLikedThisPost.value
                                            ? ReactionsType.unLike
                                            : ReactionsType.like,
                                        postModel: widget.postModel),
                                  );
                                  isCurrentUserLikedThisPost.value = !isCurrentUserLikedThisPost.value;
                                },
                                child: Text(
                                  isCurrentUserLikedThisPost.value ? S.of(context).liked : S.of(context).like,
                                  style: AppStyles.h3.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: VerticalDivider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        width: 3,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                      post: widget.postModel,
                                    ),
                                  ));
                            },
                            child: Text(
                              S.of(context).comments,
                              style: AppStyles.h3.copyWith(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
