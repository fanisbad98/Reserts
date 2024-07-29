import 'package:fl_quiz_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(test),
              height: 30.h,
            ),
            Text(
              'Opps!',
              style: textColorBold24,
            ),
            heightSpace10,
            Text(
              'Please check your internet connection\nand try again',
              style: color94SemiBold16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
