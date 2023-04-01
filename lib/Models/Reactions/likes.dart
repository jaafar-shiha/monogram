class Likes {
   Likes({
    required this.count ,
    required this.usersIds,
  });

   int count;
   List<String> usersIds;

  factory Likes.fromMap(Map<String, dynamic> json) => Likes(
        count: json["count"],
        usersIds: List<String>.from(json["users_ids"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "users_ids": List<dynamic>.from(usersIds.map((x) => x)),
      };

  Likes copyWith({
    int? count,
    List<String>? usersIds,
  }) {
    return Likes(
      count: count ?? this.count,
      usersIds: usersIds ?? this.usersIds,
    );
  }
}
