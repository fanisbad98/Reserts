import 'package:fl_quiz_app/models/payment_gateway_model.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/material.dart';

class WithdrawMethodProvider extends ChangeNotifier {
  List<PaymentGatewayData> paymentGatewayData = [];
  int selectedMethod = 0;

  void getWithdrawMethod(BuildContext context) async {
    paymentGatewayData.clear();
    paymentGatewayData = await ApiServices.fetchPaymentGateways(context);
    notifyListeners();
  }

  void changeMethod(int value) {
    selectedMethod = value;
    notifyListeners();
  }
}
