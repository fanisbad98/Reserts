import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  String status = 'waiting...';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  void checkRealtimeConnection() {
    streamSubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> event) {
      final connectivityResult = event.isNotEmpty ? event[0] : ConnectivityResult.none;

      switch (connectivityResult) {
        case ConnectivityResult.mobile:
          status = "Connected to Mobile Data";
          break;
        case ConnectivityResult.wifi:
          status = "Connected to Wifi";
          break;
        default:
          status = 'Offline';
          break;
      }
      notifyListeners();
    });
  }
}
