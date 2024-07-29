import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class ProfileProvider extends ChangeNotifier {
  String _name = global.userName!;
  String? _file;

  String get name => _name;
  String? get file => _file;

  void updateNameOrProfile(String name, String file) {
    _name = name;
    _file = file;
    notifyListeners();
  }

  void deleteImage() {
    _file = global.userPlaceholder;
    notifyListeners();
  }
}
