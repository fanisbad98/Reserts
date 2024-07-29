import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class WalletProvider extends ChangeNotifier {
  int _myPoint = global.totalPoints!;

  int get myPoint => _myPoint;

  void updateMyPoints(int value) {
    _myPoint = value;
    notifyListeners();
  }
}
