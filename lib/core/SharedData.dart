import 'package:flutter/material.dart';

class SharedData with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    print(value);
    _currentIndex = value;
    notifyListeners();
  }
}