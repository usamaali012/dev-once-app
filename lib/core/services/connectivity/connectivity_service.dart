import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  static final _instance = ConnectivityService._singleton();

  factory ConnectivityService() => _instance;

  ConnectivityService._singleton();

  final _connectivity = Connectivity();
  Connectivity get connectivity => _connectivity;

  late StreamSubscription<List<ConnectivityResult>> _subscription;
  StreamSubscription<List<ConnectivityResult>> get subscription => _subscription;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  void initialize({required VoidCallback onConnected, required VoidCallback onDisconnected}) {
    _subscription = _onStreamStart(
      (result) => _onResultReceived(result, onConnected, onDisconnected),
    );
  }

  StreamSubscription<List<ConnectivityResult>> _onStreamStart(
    StreamResultCallback onResultReceived,
  ) => _connectivity.onConnectivityChanged.listen(onResultReceived);

  void _onResultReceived(
    StreamResult result,
    VoidCallback onConnected,
    VoidCallback onDisconnected,
  ) {
    _isConnected = !result.contains(ConnectivityResult.none);
    _isConnected ? onConnected() : onDisconnected();
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void dispose() => _subscription.cancel();
}

typedef StreamResult = List<ConnectivityResult>;
typedef StreamResultCallback = ValueChanged<List<ConnectivityResult>>;
