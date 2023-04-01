import 'package:monogram/Models/post_model.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.profilePictureUrl,
    this.posts,
    this.friends,
    this.sentRequests,
    this.receivedRequests,
  });

  String id;
  String name;
  String email;
  String? password;
  String? profilePictureUrl;
  List<PostModel>? posts;
  List<String>? friends;
  List<String>? sentRequests;
  List<String>? receivedRequests;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        profilePictureUrl: json["profilePictureUrl"],
        posts: json["posts"] == null ? [] : List<PostModel>.from(json["posts"].map((post) => PostModel.fromMap(post))),
        friends: json["friends"] == null ? [] : List<String>.from(json["friends"].map((friendId) => friendId)),
        sentRequests: json["sent_requests"] == null ? [] : List<String>.from(json["sent_requests"].map((friendId) => friendId)),
        receivedRequests: json["received_requests"] == null ? [] : List<String>.from(json["received_requests"].map((friendId) => friendId)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "profilePictureUrl": profilePictureUrl,
        "posts": posts??[],
        "friends": friends,
        "sent_requests": sentRequests,
        "received_requests": receivedRequests,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? profilePictureUrl,
    List<String>? friends,
    List<String>? sentRequests,
    List<String>? receivedRequests,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      friends: friends ?? this.friends,
      sentRequests: sentRequests ?? this.sentRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
    );
  }
}
