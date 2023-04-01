import 'package:flutter/material.dart';
import 'package:monogram/View/Feed/shimmer_post_card.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerFeedPage extends StatefulWidget {
  const ShimmerFeedPage({Key? key}) : super(key: key);

  @override
  _ShimmerFeedPageState createState() => _ShimmerFeedPageState();
}

class _ShimmerFeedPageState extends State<ShimmerFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: SingleChildScrollView(
        child: Column(
          children: const [
            ShimmerPostCard(),
            ShimmerPostCard(),
            ShimmerPostCard(),
            ShimmerPostCard(),
            ShimmerPostCard(),
            ShimmerPostCard(),
          ],
        ),
      ),
    );
  }
}
