import 'package:fl_quiz_app/utils/constant.dart';
import 'package:flutter/material.dart';

class DrawDashedHorizontalLine extends CustomPainter {
  late Paint _paint;

  DrawDashedHorizontalLine() {
    _paint = Paint();
    _paint.color = primaryColor;
    _paint.strokeWidth = 1;
    _paint.strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 2.5;
    const double dashSpace = 3.5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        _paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
