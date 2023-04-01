import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Utils/error_model.dart';
import 'package:monogram/Utils/result_classes.dart';

class SignInRegisterRepository {
  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  SignInRegisterRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<ResponseState<UserCredential>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredentials.user!.updateDisplayName(name);
      UserModel user = UserModel(
        id: _firebaseAuth.currentUser!.uid,
        name: name,
        email: email,
        password: password,
      );
      FirebaseFirestore.instance.collection('Users').doc(_firebaseAuth.currentUser!.uid).set(user.toMap());
      return ResponseState.success(userCredentials);
    } on FirebaseException catch (e) {
      return ResponseState.error(
        ErrorModel(
          code: e.code,
          message: e.message!,
        ),
      );
    }
  }

  Future<ResponseState<String>> addProfilePictureToUser({required String id, required XFile profilePicture}) async {
    try {
      String fileName = id;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('profilePictures/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(profilePicture.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('Users').doc(_firebaseAuth.currentUser!.uid).update(
        {"profilePictureUrl": profilePictureUrl},
      );
      return ResponseState.success(profilePictureUrl);
    } on FirebaseException catch (e) {
      return ResponseState.error(
        ErrorModel(
          code: e.code,
          message: e.message!,
        ),
      );
    }
  }

  Future<ResponseState<UserCredential>> signInWithGoogle() async {
    await signOut();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const EmptyState();
      UserCredential? userCredential;
      try {
        userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(email: googleUser.email, password: googleUser.id);
      } on FirebaseAuthException catch (_) {
        await signUp(
          name: googleUser.displayName!,
          email: googleUser.email,
          password: googleUser.id,
        ).then((value) {
          if (value is SuccessState<UserCredential>) {
            userCredential = value.data;
          }
        });
      }
      return ResponseState.success(userCredential!);
    } on FirebaseAuthException catch (e) {
      return ResponseState.error(
        ErrorModel(
          code: e.code,
          message: e.message!,
        ),
      );
    }
  }

  Future<ResponseState<UserCredential>> signInWithCredentials({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return ResponseState.success(userCredential);
    } on FirebaseException catch (e) {
      return ResponseState.error(
        ErrorModel(
          code: e.code,
          message: e.message!,
        ),
      );
    }
  }

  Future<Future<List<void>>> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }
}
