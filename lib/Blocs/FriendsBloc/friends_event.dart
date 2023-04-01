import 'package:equatable/equatable.dart';
import 'package:monogram/Utils/operation_type.dart';

abstract class FriendsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFriends extends FriendsEvent {
  final String userId;

  GetFriends(this.userId);
}

class ManageFriendshipRequest extends FriendsEvent {
  final OperationType operationType;
  final String currentUserId;
  final String friendId;

  ManageFriendshipRequest({
    required this.operationType,
    required this.currentUserId,
    required this.friendId,
  });
}
