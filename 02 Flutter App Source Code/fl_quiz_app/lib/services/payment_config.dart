
const String applePayConfig = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "TEST",
    "displayName": "TEST",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "GR",
    "currencyCode": "EUR",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },  
    ]
  }
}''';

 String googlePayStripeConfig(double totalPrice) {
  return '''
  {
    "provider": "google_pay",
    "data": {
      "environment": "TEST",
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "allowedPaymentMethods": [
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "stripe",
              "stripe:version": "2024-04-10",
              "stripe:publishableKey": "pk_test_51PaCBWRqJUJdr2cCGPMKhTdAReTBJvvo5Gq2gZZot32ttuRoYNLb2XuuBag6cnBqeJsuW4xYvOaotLddoML2kjY900IpuIbCb0"
            }
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {
              "format": "FULL",
              "phoneNumberRequired": true
            }
          }
        }
      ],
      "merchantInfo": {
        "merchantId": "BCR2DN4TWW74Z5IS",
        "merchantName": "IOANNIS PAPADOPOULOS YPIRESIES DIADIKTYOU L.P."
      },
      "transactionInfo": {
        "totalPriceStatus": "FINAL",
        "countryCode": "GR",
        "currencyCode": "EUR",
        "totalPrice": "${totalPrice.toStringAsFixed(2)}"
      }
    }
  }
  ''';
}



