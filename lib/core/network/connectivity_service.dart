import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _controller = StreamController<NetworkStatus>.broadcast();
  NetworkStatus _currentStatus = NetworkStatus.online;

  Stream<NetworkStatus> get statusStream => _controller.stream;
  NetworkStatus get currentStatus => _currentStatus;
  bool get isOnline => _currentStatus == NetworkStatus.online;

  Future<void> initialize() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);
      _connectivity.onConnectivityChanged.listen(_updateStatus);
    } catch (e) {
      debugPrint('ConnectivityService initialization error: $e');
      _currentStatus = NetworkStatus.online;
    }
  }

  void _updateStatus(dynamic result) {
    bool hasConnection = false;

    if (result is List) {
      hasConnection = result.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);
    } else if (result is ConnectivityResult) {
      hasConnection = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    }

    _currentStatus = hasConnection ? NetworkStatus.online : NetworkStatus.offline;
    _controller.add(_currentStatus);
  }

  /// For testing/demo toggling
  void setManualStatus(NetworkStatus status) {
    _currentStatus = status;
    _controller.add(_currentStatus);
  }

  void dispose() {
    _controller.close();
  }
}
