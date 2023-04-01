import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monogram/Models/post_model.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/error_model.dart';
import 'package:monogram/Utils/operation_type.dart';
import 'package:monogram/Utils/result_classes.dart';
import 'package:monogram/generated/l10n.dart';

class FeedRepository {
  FeedRepository();

  Future<ResponseState<UserModel>> getUserData({required String userId}) async {
    ResponseState<UserModel> response = ResponseState.loading();
    try {
        await FirebaseFirestore.instance.collection('Users').doc(userId).get().then(
        (value) {
          UserModel user = UserModel.fromMap(jsonDecode(jsonEncode(value.data())));
          response = ResponseState.success(user);
        },
      );
    } on FirebaseException catch (e) {
      response = ResponseState.error(ErrorModel(code: e.code, message: e.message ?? S().errorNotFound));
    }
    return response;
  }

  Future<ResponseState<List<UserModel>>> getFriendsData({required List<String> usersIds}) async {
    ResponseState<List<UserModel>> response = ResponseState.loading();
    try {
      List<UserModel> friends = List.empty(growable: true);
      if (usersIds.isEmpty) { // Not supposed to iterate over an empty list
        return ResponseState.success(friends);
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .where("id",whereIn: usersIds,)
          .get().then((value) {
            for (var element in value.docs) {
              friends.add(UserModel.fromMap(jsonDecode(jsonEncode(element.data()))));
            }
        response = ResponseState.success(friends);
      });
    } on FirebaseException catch (e) {
      response = ResponseState.error(ErrorModel(code: e.code, message: e.message ?? S().errorNotFound));
    }
    return response;
  }


  Future<ResponseState<bool>> managePost({
    required OperationType operationType,
    PostModel? oldPostModel,
    required PostModel newPostModel,
  }) async {
    ResponseState<bool> response = ResponseState.loading();
    try {
      switch (operationType){
        case OperationType.add:
          await FirebaseFirestore.instance.collection('Users').doc(newPostModel.userId).update(
              {
                "posts": FieldValue.arrayUnion([newPostModel.toMap()]),
              }
          );
          break;
        case OperationType.update:
          await FirebaseFirestore.instance.collection('Users').doc(newPostModel.userId).update(
              {
                "posts": FieldValue.arrayRemove([oldPostModel!.toMap()]),
              }
          );
          await FirebaseFirestore.instance.collection('Users').doc(newPostModel.userId).update(
              {
                "posts": FieldValue.arrayUnion([newPostModel.toMap()]),
              }
          );
          break;
        case OperationType.delete:
          await FirebaseFirestore.instance.collection('Users').doc(newPostModel.userId).update(
              {
                "posts": FieldValue.arrayRemove([newPostModel.toMap()]),
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
