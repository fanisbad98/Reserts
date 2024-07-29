import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/providers/withdraw_method_provider.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../helper/ui_helper.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class WithdrawMethod extends StatefulWidget {
  final int points;
  final double amount;
  const WithdrawMethod({Key? key, required this.amount, required this.points})
      : super(key: key);

  @override
  State<WithdrawMethod> createState() => _WithdrawMethodState();
}

class _WithdrawMethodState extends State<WithdrawMethod> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    Provider.of<WithdrawMethodProvider>(context, listen: false)
        .getWithdrawMethod(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodyMethod(),
    );
  }

  Widget bodyMethod() {
    return Consumer<WithdrawMethodProvider>(
      builder: (context, WithdrawMethodProvider value, child) =>
          value.paymentGatewayData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      payWithButton(value),
                      heightSpace60,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Image.network(
                              '${ApiConstants.url}${value.paymentGatewayData[value.selectedMethod].image}',
                              height: 35,
                            ),
                            heightSpace10,
                            Text(
                                'Transfer with ${value.paymentGatewayData[value.selectedMethod].name}',
                                style: blackSemiBold16),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 35),
                              child: PrimaryTextField(
                                enabled: value
                                    .paymentGatewayData[value.selectedMethod]
                                    .isActive,
                                controller: _controller,
                                hintText: value
                                    .paymentGatewayData[value.selectedMethod]
                                    .inputPlaceholder,
                                keyboardType: isolateKeyboard(value
                                    .paymentGatewayData[value.selectedMethod]
                                    .inputField),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            PrimaryButton(
                              text: 'Transfer',
                              onTap: () {
                                createWithdrawalReq(value, context);
                              },
                            ),
                            heightSpace20,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void createWithdrawalReq(WithdrawMethodProvider value, BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      if (value.paymentGatewayData[value.selectedMethod].inputField ==
          'number') {
        if (validateMobileNumber(_controller.text)) {
          ApiServices.createWithdrawRequest(
              amount: widget.amount,
              points: widget.points,
              paymentMethod:
                  value.paymentGatewayData[value.selectedMethod].id.toString(),
              paymentVia: _controller.text.trim(),
              context: context);
          _controller.clear();
          UiHelper.showWithdrawDialog(context, widget.amount);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: primaryColor,
              content: Text(
                'Please enter valid mobile number',
                style: whiteSemiBold14,
              )));
        }
      } else {
        if (validateEmail(_controller.text)) {
          ApiServices.createWithdrawRequest(
              amount: widget.amount,
              points: widget.points,
              paymentMethod:
                  value.paymentGatewayData[value.selectedMethod].id.toString(),
              paymentVia: _controller.text.trim(),
              context: context);
          _controller.clear();
          UiHelper.showWithdrawDialog(context, widget.amount);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: primaryColor,
              content: Text(
                'Please enter valid email',
                style: whiteSemiBold14,
              )));
        }
      }
    } else if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: primaryColor,
          content: Text(
            value.paymentGatewayData[value.selectedMethod].inputPlaceholder!,
            style: whiteSemiBold14,
          )));
    }
  }

  Widget payWithButton(WithdrawMethodProvider providerValue) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.horizontal,
        itemCount: providerValue.paymentGatewayData.length,
        itemBuilder: (context, index) {
          bool isSelected = providerValue.selectedMethod == index;
          return GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).unfocus();
              providerValue.changeMethod(index);
            },
            child: Container(
              width: 56.95.w - 60,
              padding: const EdgeInsets.all(15.5),
              margin: index == 0
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: borderRadius5,
                  border: isSelected ? Border.all(color: primaryColor) : null,
                  boxShadow:
                      isSelected ? [primaryButtonShadow6] : [color00Shadow]),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(7.14, 11, 7.14, 8.57),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorD9),
                        borderRadius: BorderRadius.circular(15.88)),
                    child: CachedNetworkImage(
                      height: 20,
                      imageUrl:
                          '${ApiConstants.url}${providerValue.paymentGatewayData[index].image}',
                      placeholder: (context, url) => Shimmer(
                        child: ShimmerLoading(
                          child: Container(
                            height: 20,
                            width: 30,
                            decoration: BoxDecoration(
                                color: black, borderRadius: borderRadius5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  heightSpace10,
                  Text(providerValue.paymentGatewayData[index].name.toString(),
                      style: isSelected ? blackBold16 : blackSemiBold16)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Select method'),
    );
  }

  isolateKeyboard(String? inputField) {
    switch (inputField) {
      case 'text':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
    }
  }

  bool validateMobileNumber(String mobileNumber) {
    // Define a regex pattern for mobile numbers
    RegExp mobileRegex = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');

    // Check if the mobile number matches the pattern
    return mobileRegex.hasMatch(mobileNumber);
  }

  bool validateEmail(String email) {
    // Define a regex pattern for email addresses
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the email matches the pattern
    return emailRegex.hasMatch(email);
  }
}
