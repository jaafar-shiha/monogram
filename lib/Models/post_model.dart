import 'package:monogram/Models/Comments/comment.dart';
import 'package:monogram/Models/Reactions/reactions.dart';

class PostModel {
  PostModel({
    required this.userId,
    required this.userName,
    required this.userProfilePicture,
    required this.dateOfPosting,
    required this.content,
    required this.reactions,
    this.comments = const [],
  });

  String userId;
  String userName;
  String? userProfilePicture;
  DateTime dateOfPosting;
  String content;
  Reactions reactions;
  List<Comment> comments;

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
        userId: json["user_id"],
        userName: json["user_name"],
        userProfilePicture: json["user_profile_picture"],
        dateOfPosting: DateTime.parse(json["date_of_posting"]),
        content: json["content"],
        reactions: Reactions.fromMap(json["reactions"]),
        comments: List<Comment>.from(json["comments"] != null ?
          json["comments"].map((comment) => Comment.fromMap(comment)) : [],
        ),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "user_name": userName,
        "user_profile_picture": userProfilePicture,
        "date_of_posting": dateOfPosting.toIso8601String(),
        "content": content,
        "reactions": reactions.toMap(),
        "comments": comments.map((e) => e.toMap()).toList()
      };

  PostModel copyWith({
    String? userId,
    String? userName,
    String? userProfilePicture,
    DateTime? dateOfPosting,
    String? content,
    Reactions? reactions,
    List<Comment>? comments,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      dateOfPosting: dateOfPosting ?? this.dateOfPosting,
      content: content ?? this.content,
      reactions: reactions ?? this.reactions,
      comments: comments ?? this.comments,
    );
  }
}
