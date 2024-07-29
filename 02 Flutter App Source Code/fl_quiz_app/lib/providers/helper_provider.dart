import 'package:flutter/cupertino.dart';

class HelperProvider extends ChangeNotifier {
  int navigateCounter = -1;
  int selectedIndex = 0;

  void onBottomNavTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void resetSelectedIndex() {
    selectedIndex = 0;
    notifyListeners();
  }

  void incrementNavigateCount() {
    navigateCounter++;
  }
}
