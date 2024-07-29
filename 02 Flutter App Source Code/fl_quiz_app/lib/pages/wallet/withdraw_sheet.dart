import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../utils/widgets.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class WithdrawSheet extends StatefulWidget {
  const WithdrawSheet({Key? key}) : super(key: key);

  @override
  State<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<WithdrawSheet> {
  final _pointsController = TextEditingController();
  final _amtController = TextEditingController();

  @override
  void dispose() {
    _pointsController.dispose();
    _amtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(top: 15),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text('Withdraw amount', style: blackBold18)),
            heightSpace20,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter point', style: blackSemiBold16),
                      heightSpace10,
                      PrimaryContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Image.asset(pointsImage, height: 20),
                            widthSpace5,
                            Expanded(
                              child: TextField(
                                  controller: _pointsController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      /* var tempValue = (int.parse(value) / 1000);
                                      if (tempValue.toString().length == 3) {
                                        _amtController.text = tempValue
                                            .toString()
                                            .padRight(4, '0');
                                      } else {
                                        _amtController.text = tempValue
                                            .toString()
                                            .substring(0, 4);
                                      } */
                                      var tempValue = (int.parse(value) /
                                          (1000 / global.conversionRate));
                                      _amtController.text =
                                          tempValue.toString().padRight(4, '0');
                                    } else {
                                      _amtController.clear();
                                    }
                                  },
                                  cursorColor: primaryColor,
                                  maxLength: 10,
                                  style: color94SemiBold18,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      hintText: 'point',
                                      border: InputBorder.none,
                                      hintStyle: color94SemiBold18)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widthSpace20,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You will get', style: blackSemiBold16),
                      heightSpace10,
                      PrimaryContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(global.currencySymbol,
                                style: color94SemiBold18),
                            widthSpace5,
                            Expanded(
                              child: TextField(
                                  enabled: false,
                                  controller: _amtController,
                                  cursorColor: primaryColor,
                                  style: color94SemiBold18,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      hintText: 'amount',
                                      border: InputBorder.none,
                                      hintStyle: color94SemiBold18)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            heightSpace40,
            PrimaryButton(
              text: 'Withdraw',
              onTap: () {
                if (_pointsController.text.isEmpty) {
                  Navigator.pop(context);
                } else if (int.parse(_pointsController.text) <=
                        global.totalPoints! &&
                    double.parse(_amtController.text) >=
                        global.minWithdrawAmount) {
                  Navigator.popAndPushNamed(context, '/WithdrawMethod',
                      arguments: [
                        int.parse(_pointsController.text),
                        double.parse(_amtController.text.trim())
                      ]);
                } else if (int.parse(_pointsController.text) >
                    global.totalPoints!) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: primaryColor,
                      content: Text(
                        'You dont have enough points',
                        style: whiteSemiBold14,
                      )));
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: primaryColor,
                      content: Text(
                        'Amount must be greater than \$${global.minWithdrawAmount}',
                        style: whiteSemiBold14,
                      )));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
