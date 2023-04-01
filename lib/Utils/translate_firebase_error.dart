import 'package:flutter/material.dart';
import 'package:monogram/generated/l10n.dart';

String translateErrorMessage(BuildContext context, String errorCode, String errorMessage) {
  switch(errorCode){
    case 'weak-password':
      return S.of(context).passwordWeak;
    case 'email-already-in-use':
      return S.of(context).emailExists;
    case 'network-request-failed':
      return S.of(context).requestFailed;
    default:
      return errorMessage;
  }
}