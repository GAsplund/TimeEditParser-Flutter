import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Theming with ChangeNotifier {
  //static Theming instance = new Theming();

  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode getCurrentTheme() {
    return _currentTheme;
  }

  void changeTheme(int mode) {
    switch (mode) {
      case 1:
        _currentTheme = ThemeMode.dark;
        break;
      case 2:
        _currentTheme = ThemeMode.light;
        break;
      case 0:
      default:
        _currentTheme = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
