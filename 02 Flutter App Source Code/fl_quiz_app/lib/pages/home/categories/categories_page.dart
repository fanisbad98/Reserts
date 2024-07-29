import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart' as pay;
import 'package:fl_quiz_app/services/payment_config.dart';
import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/models/categories_model.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:fl_quiz_app/utils/globals.dart' as globals;
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import 'package:http/http.dart' as http;

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  List<AllCategoriesData>? categoriesData;
  bool isLoading = true;
  double selectedAmount = 0.0;
  bool isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await ApiServices.fetchAllCategories(context);
      setState(() {
        categoriesData = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching categories: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

 Future<Map<String, dynamic>> stripeMakePaymentIntents(double amount) async {
  const url = 'https://api.stripe.com/v1/payment_intents';
  final data = {
    'amount': "${((amount) * 100).toInt()}",
    'currency': "EUR",
    'automatic_payment_methods[enabled]': "true",
    'receipt_email': "${globals.email}",
    'description': "${globals.appName} donation to help research!",
  };
  // print("------------- ${data}");

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer ${globals.stripeSecretKey}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: data,
  );

  if (response.statusCode == 200) {
    // print("-------------- ${response.body}");
    return json.decode(response.body);
  } else {
    throw Exception('Failed to create payment intent');
  }
}
  Future<bool> stripeMakePayment(paymentResult, double amount) async {
  try {
    final response = await stripeMakePaymentIntents(amount);
    final clientSecret = response['client_secret'];

    final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
    final tokenJson = json.decode(token) as Map<String, dynamic>;
    final tokenId = tokenJson['id'];

    if (tokenId == null) {
      throw Exception('Token ID is null');
    }

    final params = PaymentMethodParams.cardFromToken(
      paymentMethodData: PaymentMethodDataCardFromToken(
        token: tokenId,
      ),
    );

    if (clientSecret == null) {
      throw Exception('ClientSecret is null');
    }

    final result = await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: params,
    );

    if (result.status == PaymentIntentsStatus.Succeeded) {
      print('Payment confirmation succeeded');
      return true;
    } else {
      print('Payment confirmation failed with status ${result.status}');
      return false;
    }
  } catch (e) {
    print('Error processing Stripe payment: $e');
    return false;
  }
}
void onGooglePayResult(AllCategoriesData selectedCategory ,double amount, Map<String, dynamic> paymentResult) async {
  try{
    setState(() {
      isProcessingPayment =true;
    });
    final success = await stripeMakePayment(paymentResult, amount);
    if (success) {
      await Future.delayed(const Duration(seconds: 1));
      confirmedPayment(selectedCategory, amount, context);
    } else {
      final errorDetail = paymentResult['errorMessage'] ?? 'Google Pay payment failed.';
      _showPaymentFailedDialog(context, 'Google Pay payment failed.', errorDetail);
    }
  }catch (e) {
      print('Error processing Google Pay payment: $e');
    } finally {
      setState(() {
        isProcessingPayment = false;
      });
    }
  }

void onApplePayResult(AllCategoriesData selectedCategory, double amount, Map<String, dynamic> paymentResult) async {
  try{
    setState(() {
      isProcessingPayment = true;
    });
    final success = await stripeMakePayment(paymentResult, amount);
    if (success) {
      confirmedPayment(selectedCategory, amount, context);
    } else {
       final errorDetail = paymentResult['errorMessage'] ?? 'Apple Pay payment failed.';
      _showPaymentFailedDialog(context, 'Apple Pay payment failed.', errorDetail);
    }
  } catch (e){
    print('Error processing Apple Pay payment: $e');
  } finally{
    setState(() { 
      isProcessingPayment = false;
    });
  }
}


  void confirmedPayment(AllCategoriesData selectedCategory, double selectedAmount, context) {
    final pointsToAdd = (selectedAmount * 1000).toInt();
    ApiServices.updateCategoryPoints(selectedCategory.id, pointsToAdd, context);
    Navigator.pushNamed(
      context,
      '/DonationSuccessPage',
      arguments: [
        selectedCategory.name,
        selectedAmount,
        pointsToAdd,
      ]
     );
  }

  void _showPaymentFailedDialog(BuildContext context, String message, [String? errorDetail]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Payment Failed', style: color5ESemiBold18),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: color0SemiBold16),
            if (errorDetail != null) ...[
              const SizedBox(height: 10),
              Text('Error: $errorDetail', style: color0SemiBold16),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Continue', style: color0SemiBold18),
          )
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: isLoading
          ? Shimmer(
              linearGradient: shimmerGradient,
              child: ShimmerLoading(
                isLoading: true,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .9,
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return const PrimaryContainer();
                  },
                ),
              ),
            )
          : categoriesData == null || categoriesData!.isEmpty
              ? const Center(child: Text('No categories available'))
              : Stack(
                  children: [
                    GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: categoriesData!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .9,
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return PrimaryContainer(
                          onTap: () {
                            globals.tempQuizId = categoriesData![index].id;
                            Navigator.pushNamed(
                              context,
                              '/PlayQuizPage',
                              arguments: [
                                categoriesData![index].id,
                                categoriesData![index].name,
                              ],
                            );
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5.0),
                          color: colorC3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: profileBgColor,
                                backgroundImage: NetworkImage(
                                  '${ApiConstants.url}${categoriesData![index].image}',
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    pointsImage,
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${categoriesData![index].points ?? 0} ',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(
                                categoriesData![index].name,
                                style: textColorBold16,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          _showDonateDialog(context, categoriesData!);
                        },
                        backgroundColor: color5E,
                        child: const Icon(Icons.monetization_on, color: colorE2),
                        tooltip: 'Donate',
                      ),
                    ),
                    if (isProcessingPayment)
                      Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: Colors.transparent,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(colorC3), 
                              strokeWidth: 4.5, 
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }


void _showDonateDialog(BuildContext context, List<AllCategoriesData> categoriesData) {
  AllCategoriesData? selectedCategory;
  bool isAmountLocked = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Help Research',
                    style: blackBold22),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<AllCategoriesData>(
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    hint:  Text('Select a research', style: blackBold16),
                    value: selectedCategory,
                    onChanged: isAmountLocked ? null : (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedAmount = 0.0;  
                        isAmountLocked = false;  
                      });
                    },
                    items: categoriesData.map((category) {
                      return DropdownMenuItem<AllCategoriesData>(
                        value: category,
                        child: Text(
                          category.name,
                          style: blackBold16,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (selectedCategory != null) ...[
                     Text(
                      'Select an amount :',
                      style: blackBold18
                    ),
                    const SizedBox(height: 10),
                    for (double amount in [1.0, 2.5, 5.0, 10.0]) ...[
                    GestureDetector(
                      onTap: isAmountLocked ? null : () {
                        setState(() {
                          selectedAmount = amount;
                          isAmountLocked = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: selectedAmount == amount ? colorC3 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedAmount == amount ? colorC3 : Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: selectedAmount == amount ? colorC3.withOpacity(0.5) : Colors.grey.shade300,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Radio<double>(
        value: amount,
        groupValue: selectedAmount,
        onChanged: isAmountLocked ? null : (value) {
          setState(() {
            selectedAmount = value!;
            isAmountLocked = true;
          });
        },
        activeColor: colorC3,
      ),
       title: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      'Donate $amount ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: selectedAmount == amount ? FontWeight.bold : FontWeight.normal,
        color: selectedAmount == amount ? Colors.white : Colors.black,
      ),
    ),
    Icon(
      Icons.euro_outlined,
      color: selectedAmount == amount ? color0: colorC3,
    ),
    Text(
      ' for ${((amount * 1000).toInt())} points',
      style: TextStyle(
        fontSize: 16,
        fontWeight: selectedAmount == amount ? FontWeight.bold : FontWeight.normal,
        color: selectedAmount == amount ? Colors.white : Colors.black,
      ),
    ),
  ],
),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (selectedCategory != null && selectedAmount != 0.0) ...[
                    Container(
                      color: Colors.transparent,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Platform.isIOS
                              ? pay.ApplePayButton(
                                  paymentConfiguration: pay.PaymentConfiguration.fromJsonString(applePayConfig),
                                  paymentItems: [
                                    pay.PaymentItem(
                                      label: 'Total',
                                      amount: selectedAmount.toStringAsFixed(2),
                                      status: pay.PaymentItemStatus.final_price,
                                    ),
                                  ],
                                  style: pay.ApplePayButtonStyle.black,
                                  type: pay.ApplePayButtonType.buy,
                                  onPaymentResult: (result) async {
                                    Navigator.pop(context);
                                    onApplePayResult(selectedCategory!, selectedAmount, result);
                                  },
                                  loadingIndicator: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : pay.GooglePayButton(
                                  paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
                                    googlePayStripeConfig(selectedAmount)
                                  ),
                                  paymentItems: [
                                    pay.PaymentItem(
                                      label: 'Total',
                                      amount: selectedAmount.toStringAsFixed(2),
                                      status: pay.PaymentItemStatus.final_price,
                                    ),
                                  ],
                                  type: pay.GooglePayButtonType.pay,
                                  onPaymentResult: (result) async {
                                    Navigator.pop(context);
                                    onGooglePayResult(selectedCategory!, selectedAmount, result);
                                  },
                                  loadingIndicator: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ],
                ],
              ),
            ),
          );
        },
      );
    },
  );
}




  PreferredSize appBarMethod() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(
        title: 'Researches',
      ),
    );
  }
}
