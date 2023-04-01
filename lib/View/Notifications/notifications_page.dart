import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_bloc.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_event.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_state.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/View/Friends/shimmer_friends_page.dart';
import 'package:monogram/View/Friends/user_card.dart';
import 'package:monogram/locator.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late FriendsBloc friendsBloc = BlocProvider.of<FriendsBloc>(context);

  @override
  void initState() {
    friendsBloc.add(GetFriends(locator<MainApp>().user!.id));
    super.initState();
  }

  List<UserModel> community = List.empty(growable: true);

  ValueNotifier<bool> isShimmerLoading = ValueNotifier(true);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BlocListener<FriendsBloc, FriendsState>(
        bloc: friendsBloc,
        listenWhen: (previousState, newState) {
          return previousState != newState;
        },
        listener: (context, state) async {
          setState(() {
            isLoading = false;
          });
          if (state is SuccessFriendsState) {
            community = state.friends;
            isShimmerLoading.value = false;
          } else if (state is ErrorFriendsState) {
            isShimmerLoading.value = false;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
              ..showSnackBar(appSnackBar(text: state.error.message));
          }
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: isShimmerLoading,
          builder: (context, val, child) {
            return isShimmerLoading.value
                ? const ShimmerFriendsPage()
                : Column(
                    children: [
                      Column(
                        children: community
                            .where((element) => (locator<MainApp>().user!.receivedRequests ?? []).contains(element.id))
                            .map(
                              (user) => UserCard(
                                user: user,
                                onLoading: (value) {
                                  setState(() {
                                    isLoading = value;
                                  });
                                },
                                onReceivingRequest: () {
                                  locator<MainApp>().user!.receivedRequests?.remove(user.id);
                                  locator<MainApp>().user!.friends?.add(user.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
