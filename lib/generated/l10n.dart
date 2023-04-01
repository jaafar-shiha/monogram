// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `New user?`
  String get newUser {
    return Intl.message(
      'New user?',
      name: 'newUser',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email!`
  String get invalidEmail {
    return Intl.message(
      'Invalid email!',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all required fields.`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill all required fields.',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `The password and it's confirmation not identical.`
  String get passwordsNotIdentical {
    return Intl.message(
      'The password and it\'s confirmation not identical.',
      name: 'passwordsNotIdentical',
      desc: '',
      args: [],
    );
  }

  /// `Error not found!`
  String get errorNotFound {
    return Intl.message(
      'Error not found!',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `There is no error`
  String get thereIsNoError {
    return Intl.message(
      'There is no error',
      name: 'thereIsNoError',
      desc: '',
      args: [],
    );
  }

  /// `Password should be least 6 characters`
  String get passwordWeak {
    return Intl.message(
      'Password should be least 6 characters',
      name: 'passwordWeak',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account.`
  String get emailExists {
    return Intl.message(
      'The email address is already in use by another account.',
      name: 'emailExists',
      desc: '',
      args: [],
    );
  }

  /// `A network error has occurred.`
  String get requestFailed {
    return Intl.message(
      'A network error has occurred.',
      name: 'requestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Add a picture for your profile`
  String get addAPictureForYourProfile {
    return Intl.message(
      'Add a picture for your profile',
      name: 'addAPictureForYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save and continue`
  String get saveAndContinue {
    return Intl.message(
      'Save and continue',
      name: 'saveAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `Continue without adding a photo`
  String get continueWithoutAddingAPhoto {
    return Intl.message(
      'Continue without adding a photo',
      name: 'continueWithoutAddingAPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Monogram`
  String get monogram {
    return Intl.message(
      'Monogram',
      name: 'monogram',
      desc: '',
      args: [],
    );
  }

  /// `Posted on`
  String get postedOn {
    return Intl.message(
      'Posted on',
      name: 'postedOn',
      desc: '',
      args: [],
    );
  }

  /// `Add post`
  String get addPost {
    return Intl.message(
      'Add post',
      name: 'addPost',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to share?`
  String get whatDoYouWantToShare {
    return Intl.message(
      'What do you want to share?',
      name: 'whatDoYouWantToShare',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Monogram`
  String get welcomeToMonogram {
    return Intl.message(
      'Welcome to Monogram',
      name: 'welcomeToMonogram',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit post`
  String get editPost {
    return Intl.message(
      'Edit post',
      name: 'editPost',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to confirm deleting this?`
  String get doYouWantToDeleteThis {
    return Intl.message(
      'Do you want to confirm deleting this?',
      name: 'doYouWantToDeleteThis',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Liked`
  String get liked {
    return Intl.message(
      'Liked',
      name: 'liked',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment`
  String get writeAComment {
    return Intl.message(
      'Write a comment',
      name: 'writeAComment',
      desc: '',
      args: [],
    );
  }

  /// `Edit comment`
  String get editComment {
    return Intl.message(
      'Edit comment',
      name: 'editComment',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get doYouWantToLogout {
    return Intl.message(
      'Do you want to log out?',
      name: 'doYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get addFriend {
    return Intl.message(
      'Add friend',
      name: 'addFriend',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Account page`
  String get accountPage {
    return Intl.message(
      'Account page',
      name: 'accountPage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
