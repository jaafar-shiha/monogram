import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/error_model.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/Utils/result_classes.dart';
import 'package:monogram/generated/l10n.dart';

class FriendsRepository {
  FriendsRepository();

  Future<ResponseState<List<UserModel>>> getFriendsData({required String userId}) async {
    ResponseState<List<UserModel>> response = ResponseState.loading();
    try {
      await FirebaseFirestore.instance.collection('Users').get().then(
            (value) {
              List<UserModel> friends = List.empty(growable: true);
              value.docs.map((e) => friends.add(UserModel.fromMap(jsonDecode(jsonEncode(e.data()))))).toList();
              friends.removeWhere((element) => element.id == userId);
          response = ResponseState.success(friends);
        },
      );
    } on FirebaseException catch (e) {
      response = ResponseState.error(ErrorModel(code: e.code, message: e.message ?? S().errorNotFound));
    }
    return response;
  }

  Future<ResponseState<bool>> manageFriendship({
    required OperationType operationType,
    required String userId,
    required String friendId,
  }) async {
    ResponseState<bool> response = ResponseState.loading();
    try {
      switch (operationType){
        case OperationType.sendRequest:
          await FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                "sent_requests": FieldValue.arrayUnion([friendId]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(friendId).update(
              {
                "received_requests": FieldValue.arrayUnion([userId]),
              }
          );
          break;
        case OperationType.withdrawRequest:
          await FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                "sent_requests": FieldValue.arrayRemove([friendId]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(friendId).update(
              {
                "received_requests": FieldValue.arrayRemove([userId]),
              }
          );
          break;
        case OperationType.accept:
          await FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                "received_requests": FieldValue.arrayRemove([friendId]),
                "friends": FieldValue.arrayUnion([friendId]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(friendId).update(
              {
                "sent_requests": FieldValue.arrayRemove([userId]),
                "friends": FieldValue.arrayUnion([userId]),
              }
          );
          break;
        case OperationType.reject:
          await FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                "received_requests": FieldValue.arrayRemove([friendId]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(friendId).update(
              {
                "sent_requests": FieldValue.arrayRemove([userId]),
              }
          );
          break;
        case OperationType.delete:
          await FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                "friends": FieldValue.arrayRemove([friendId]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(friendId).update(
              {
                "friends": FieldValue.arrayRemove([userId]),
              }
          );
          break;
        default:
          break;
      }
      response = ResponseState.success(true);
    } on FirebaseException catch (e) {
      response = ResponseState.error(ErrorModel(code: e.code, message: e.message ?? S().errorNotFound));
    }
    return response;
  }

}
