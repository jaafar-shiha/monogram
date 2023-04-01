import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monogram/Utils/error_model.dart';
import 'package:monogram/Utils/result_classes.dart';

class AccountRepository {
  Future<ResponseState<bool>> updateUserAccount({
    required String id,
    required String name,
  }) async {
    try {
      FirebaseFirestore.instance.collection('Users').doc(id).update(
        {
          "name": name,
        },
      );
      return ResponseState.success(true);
    } on FirebaseException catch (e) {
      return ResponseState.error(
        ErrorModel(
          code: e.code,
          message: e.message!,
        ),
      );
    }
  }
}
