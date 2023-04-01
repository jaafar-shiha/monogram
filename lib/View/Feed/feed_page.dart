import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/SharedWidgets/app_dialog.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/Utils/translate_firebase_error.dart';
import 'package:monogram/Blocs/FeedBloc/feed_bloc.dart';
import 'package:monogram/Blocs/FeedBloc/feed_event.dart';
import 'package:monogram/Blocs/FeedBloc/feed_state.dart';
import 'package:monogram/Models/post_model.dart';
import 'package:monogram/View/Feed/post_card.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shimmer_feed_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final FeedBloc _feedBloc = BlocProvider.of<FeedBloc>(context);

  @override
  void initState() {
    _feedBloc.add(
      GetPosts(userId: locator<MainApp>().user!.id),
    );
    super.initState();
  }

  ValueNotifier<List<PostModel>> posts = ValueNotifier([]);

  ValueNotifier<bool> isShimmerLoading = ValueNotifier(true);

  ValueNotifier<bool> isProgressHudLoading = ValueNotifier(false);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      bloc: _feedBloc,
      listenWhen: (previousState, newState) {
        return previousState != newState;
      },
      listener: (context, state) {
        if (state is SuccessFeedState) {
          locator<MainApp>().user = state.user;
          _feedBloc.add(GetFriendsData(usersIds: state.user.friends??[]));
        } else if (state is GettingFriendsDataSucceededState){
          posts.value =  locator<MainApp>().user!.posts??[];
          for (var e in state.friends) {
            posts.value.addAll(e.posts??[]);
          }
          isShimmerLoading.value = false;
          refreshController.refreshToIdle();
        }
        else if (state is GettingFriendsDataFailedState) {
          isShimmerLoading.value = false;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: translateErrorMessage(context, state.error.code, state.error.message)));
        } else if (state is ErrorFeedState) {
          isShimmerLoading.value = false;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: translateErrorMessage(context, state.error.code, state.error.message)));
        } else if (state is ManagePostSucceededState) {
          isProgressHudLoading.value = false;
          Navigator.pop(context);
        } else if (state is ManagePostFailedState) {
          isProgressHudLoading.value = false;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: state.error.message));
          Navigator.pop(context);
        }
      },
      child: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () {
          _feedBloc.add(
            GetPosts(userId: locator<MainApp>().user!.id),
          );
        },
        child: ValueListenableBuilder(
          valueListenable: isShimmerLoading,
          builder: (context, val, child) {
            return isShimmerLoading.value
                ? const ShimmerFeedPage()
                : ValueListenableBuilder(
                    valueListenable: isProgressHudLoading,
                    builder: (context, _, __) {
                      return ModalProgressHUD(
                        inAsyncCall: isProgressHudLoading.value,
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder(
                            valueListenable: posts,
                            builder: (context, val, child) {
                              return Column(
                                children: posts.value
                                    .map(
                                      (post) => PostCard(
                                        postModel: post,
                                        onDelete: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AppDialog.showAlertDialog(title: S().doYouWantToDeleteThis, actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Text(
                                                          S().no,
                                                          style: AppStyles.h3,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        isProgressHudLoading.value = true;
                                                        _feedBloc.add(ManagePost(
                                                            postOperationType: OperationType.delete, newPostModel: post));
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Text(
                                                          S().yes,
                                                          style: AppStyles.h3,
                                                        ),
                                                      ),
                                                    ),
                                                  ]));
                                        },
                                      ),
                                    )
                                    .toList()
                                    .reversed
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }
}
