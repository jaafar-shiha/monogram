import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/Comments/comment.dart';
import 'package:monogram/View/Feed/Comments/edit_comment_page.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function onDelete;
  final Function(String) onUpdate;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Map<String, VoidCallback> menuChoices = {};

  @override
  void initState() {
    initMenu();
    super.initState();
  }

  String? newCommentContent;

  void initMenu() {
    menuChoices.putIfAbsent(
        S().edit,
        () => () async {
              newCommentContent = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCommentPage(
                          content: widget.comment.content,
                        )),
              );
              if (newCommentContent != null && newCommentContent != '') {
                widget.onUpdate(newCommentContent!);
              }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    widget.comment.userName,
                    style: AppStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.comment.profilePicture,
                    ),
                  ),
                  trailing: widget.comment.userId == locator<MainApp>().user!.id ? PopupMenuButton<String>(
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
                  ) : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    widget.comment.content,
                    style: AppStyles.h3,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              style: ButtonStyle(
                alignment: Alignment.topCenter,
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              onPressed: () {},
              child: Text(
                S.of(context).like,
                style: AppStyles.h3,
              ))
        ],
      ),
    );
  }
}
