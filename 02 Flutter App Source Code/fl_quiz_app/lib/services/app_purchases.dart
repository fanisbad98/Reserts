// import 'dart:async';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_quiz_app/services/api_services.dart';

// typedef void DonationSuccessCallback();

// class AppPurchases {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   final BuildContext context;
//   final DonationSuccessCallback onDonationSuccess;

//   StreamSubscription<List<PurchaseDetails>>? _purchaseStreamSubscription;


//   static const Map<String, int> productPointsMap = {
//     'd1000': 1000,
//     'd2500': 2500,
//     'd5000': 5000,
//     'd10000': 10000,
//   };

//   AppPurchases(this.context, {required this.onDonationSuccess});

//   Future<void> init() async {
//     final bool available = await _inAppPurchase.isAvailable();
//     if (!available) {
//       print('In-app purchases are not available on this device/platform');
//       return;
//     }
//     await _inAppPurchase.restorePurchases();
//   }

//   Future<List<ProductDetails>> getAvailableProducts(List<String> productIds) async {
//     final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds.toSet());
//     if (response.error != null) {
//       print('Error fetching product details: ${response.error}');
//       return [];
//     }
//     return response.productDetails;
//   }

//   Future<void> initiatePurchase(String productId, String categoryId) async {
//     final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({productId});
//     if (response.productDetails.isEmpty) {
//       print('Product not found');
//       return;
//     }
//     final productDetails = response.productDetails.first;
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
//     try {
//       await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
//     } catch (error) {
//       print('Error initiating purchase: $error');
//     }
//   }

//   Future<void> handlePurchaseResponse(PurchaseDetails purchaseDetails, String categoryId) async {
//     if (purchaseDetails.status == PurchaseStatus.purchased) {
//         String productId = purchaseDetails.productID;
//         if (productPointsMap.containsKey(productId)) {
//             int points = productPointsMap[productId] ?? 0;
//             await addPointsToCategory(categoryId, points);
//             onDonationSuccess();
//             Navigator.pop(context);
//             Navigator.pop(context);
//         } else {
//             print('Invalid product ID: $productId');
//         }
//         _purchaseStreamSubscription?.cancel();
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Donation successful.'),
//     ));
//     } else if (purchaseDetails.status == PurchaseStatus.error){
//         print('Purchase error: ${purchaseDetails.error}');
//         Navigator.pop(context);
//     }
// }

//   Future<void> addPointsToCategory(String categoryId, int donatedPoints) async {
//     try {
//       await ApiServices.updateCategoryPoints(categoryId, donatedPoints, context);
//       print('Updated category points for the selected category ID: $categoryId');
//     } catch (error) {
//       print('Error updating the category points: $error');
//     }
//   }

//   void listenToPurchaseUpdates(String categoryId) {
//     final purchaseUpdated = InAppPurchase.instance.purchaseStream;
//     _purchaseStreamSubscription = purchaseUpdated.listen((purchaseDetailsList) {
//         for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
//             handlePurchaseResponse(purchaseDetails, categoryId);
//         }
//     }, onError: (error) {
//         print('Error in purchase stream: $error');
//     });
// }

// void cancelPurchaseUpdatesSubscription() {
//     _purchaseStreamSubscription?.cancel();
// }


//   Future<void> processAvaliableProducts() async{
//     List<String> productIds = AppPurchases.productPointsMap.keys.toList();
//     List<ProductDetails> availableProducts =  await getAvailableProducts(productIds);

//     for (ProductDetails product in availableProducts){
//       int points = AppPurchases.productPointsMap[product.id] ?? 0;
//       print('Product: ${product.title}, Points: $points');
//     }
//   }
// } 
