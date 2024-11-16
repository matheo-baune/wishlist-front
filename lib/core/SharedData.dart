import 'package:flutter/material.dart';

import 'models/UserModel.dart';

class SharedData with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}