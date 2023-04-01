import 'package:flutter/material.dart';
import 'package:monogram/View/Feed/shimmer_post_card.dart';
import 'package:monogram/View/Friends/shimmer_friend_card.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerFriendsPage extends StatefulWidget {
  const ShimmerFriendsPage({Key? key}) : super(key: key);

  @override
  _ShimmerFriendsPageState createState() => _ShimmerFriendsPageState();
}

class _ShimmerFriendsPageState extends State<ShimmerFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: SingleChildScrollView(
        child: Column(
          children: const [
            ShimmerFriendCard(),
            ShimmerFriendCard(),
            ShimmerFriendCard(),
            ShimmerFriendCard(),
            ShimmerFriendCard(),
            ShimmerFriendCard(),
          ],
        ),
      ),
    );
  }
}
