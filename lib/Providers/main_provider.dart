import 'package:flutter/cupertino.dart';
import 'package:monogram/Utils/tabs_enum.dart';

class MainProvider with ChangeNotifier{
  String? _languageCode;

  String? get languageCode => _languageCode;

  void setLanguage(String languageCode){
    _languageCode = languageCode;
    notifyListeners();
  }
}