import 'package:flutter/material.dart';

class UserIDind with ChangeNotifier {
  int _userID = 0;
  int get userID => _userID;

  void setUserID(int userID) {
    _userID = userID;
    notifyListeners();
  }
}
