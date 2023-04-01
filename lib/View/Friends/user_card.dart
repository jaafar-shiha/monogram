import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_bloc.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_event.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_state.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class UserCard extends StatefulWidget {
  final UserModel user;
  final Function(bool) onLoading;
  final Function? onSendingRequest;
  final Function? onWithdrawingRequest;
  final Function? onDeleting;
  final Function? onReceivingRequest;

  const UserCard({
    Key? key,
    required this.user,
    required this.onLoading,
     this.onSendingRequest,
     this.onWithdrawingRequest,
     this.onDeleting,
     this.onReceivingRequest,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    super.initState();
  }

  late FriendsBloc friendsBloc = BlocProvider.of<FriendsBloc>(context);

  String? addedFriend;

  @override
  Widget build(BuildContext context) {
    String buttonName = '';
    if ((locator<MainApp>().user!.sentRequests ?? []).contains(
      widget.user.id,
    )){
      buttonName = S.of(context).withdraw;
    }
    else if ((locator<MainApp>().user!.receivedRequests ?? []).contains(
      widget.user.id,
    )){
      buttonName = 'Accept';
    }
    else if ((locator<MainApp>().user!.friends ?? []).contains(
      widget.user.id,
    )){
      buttonName = S.of(context).delete;
    }
    else {
      buttonName = S.of(context).addFriend;
    }
    return BlocListener<FriendsBloc, FriendsState>(
      bloc: friendsBloc,
      listenWhen: (previousState, newState) {
        return previousState != newState;
      },
      listener: (context, state) {
        widget.onLoading(false);
        if (state is SuccessManagingFriendshipState) {}
        else if (state is ErrorManagingFriendshipState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: state.error.message));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        child: Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 24,
                      backgroundImage: widget.user.profilePictureUrl != null
                          ? NetworkImage(
                        widget.user.profilePictureUrl!,
                      )
                          : const AssetImage(
                        'assets/images/no_profile_picture.png',
                      ) as ImageProvider,
                    ),
                  ),
                  title: Text(
                    widget.user.name,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        addedFriend = widget.user.id;
                        widget.onLoading(true);
                        if ((locator<MainApp>().user!.receivedRequests??[]).contains(addedFriend)){
                          friendsBloc.add(ManageFriendshipRequest(
                              operationType:OperationType.accept,
                              currentUserId: locator<MainApp>().user!.id,
                              friendId: widget.user.id));
                          if (widget.onReceivingRequest != null){
                            widget.onReceivingRequest!();
                          }
                          return;
                        }
                        if ((locator<MainApp>().user!.friends??[]).contains(addedFriend)){
                          friendsBloc.add(ManageFriendshipRequest(
                              operationType: locator<MainApp>().user!.friends!.contains(
                                addedFriend,
                              )
                                  ? OperationType.delete
                                  : OperationType.accept,
                              currentUserId: locator<MainApp>().user!.id,
                              friendId: widget.user.id));
                          widget.onDeleting!();
                          return;
                        }
                        friendsBloc.add(ManageFriendshipRequest(
                            operationType: (locator<MainApp>().user!.sentRequests??[]).contains(
                              addedFriend,
                            )
                                ? OperationType.withdrawRequest
                                : OperationType.sendRequest,
                            currentUserId: locator<MainApp>().user!.id,
                            friendId: widget.user.id));
                        if ((locator<MainApp>().user!.sentRequests ?? []).contains(
                          addedFriend,
                        )) {
                          widget.onWithdrawingRequest!();
                        }
                        else {
                          widget.onSendingRequest!();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>((locator<MainApp>().user!.sentRequests ?? []).contains(
                          widget.user.id,
                        )
                            ? AppColors.red
                            : AppColors.grey),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      child: Text(
                          buttonName,

                          style: AppStyles.h2.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
