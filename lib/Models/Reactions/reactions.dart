import 'package:monogram/Models/Reactions/likes.dart';

class Reactions {
     Reactions({
     required this.likes,
  });

   Likes likes;

  factory Reactions.fromMap(Map<String, dynamic> json) => Reactions(
    likes: Likes.fromMap(json["likes"]),
  );

  Map<String, dynamic> toMap() {
    return {
      "likes": likes.toMap(),
    };
  }

  Reactions copyWith({
    required Likes likes,
  }) {
    return Reactions(
      likes: likes,
    );
  }

}