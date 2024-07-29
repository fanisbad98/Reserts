import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class LeaderBoardProvider extends ChangeNotifier {
  String topOne = '';
  String topSec = '';
  String topThird = '';
  int? topOnePoint = 0;
  int? topSecPoint = 0;
  int? topThirdPoint = 0;
  String topOneProfilePic = global.userPlaceholder;
  String topSecProfilePic = global.userPlaceholder;
  String topThirdProfilePic = global.userPlaceholder;
  bool isAppBarCollapsed = false;

  void getTopThreeUser({
    required String top1,
    required int top1Point,
    required String top1ProfilePic,
    required String top2,
    required int top2Point,
    required String top2ProfilePic,
    required String top3,
    required int top3Point,
    required String top3ProfilePic,
  }) {
    topOne = top1;
    topOnePoint = top1Point;
    topOneProfilePic = top1ProfilePic;
    topSec = top2;
    topSecPoint = top2Point;
    topSecProfilePic = top2ProfilePic;
    topThird = top3;
    topThirdPoint = top3Point;
    topThirdProfilePic = top3ProfilePic;
    notifyListeners();
  }

  void checkWetherAppbarCollapsed(ScrollController scrollController) {
    scrollController.addListener(() {
      if (scrollController.offset > 0 && !isAppBarCollapsed) {
        isAppBarCollapsed = true;
        notifyListeners();
      } else if (scrollController.offset <= 0 && isAppBarCollapsed) {
        isAppBarCollapsed = false;
        notifyListeners();
      }
    });
  }
}
