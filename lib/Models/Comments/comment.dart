class Comment {
  Comment({
    required this.userId,
    required this.userName,
    required this.content,
    required this.profilePicture,
  });

  String userId;
  String userName;
  String content;
  String profilePicture;

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
    userId: json["user_id"],
    userName: json["user_name"],
    content: json["content"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "user_name": userName,
    "content": content,
    "profile_picture": profilePicture,
  };


  Comment copyWith({
    String? userId,
    String? userName,
    String? content,
    String? profilePicture,
  }) {
    return Comment(
      userId: userId?? this.userId,
      userName: userName?? this.userName,
      content: content?? this.content,
      profilePicture: profilePicture?? this.profilePicture,
    );
  }
}
