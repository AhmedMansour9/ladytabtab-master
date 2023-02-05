import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetChecker {
  static final InternetChecker _singleton = InternetChecker._internal();

  InternetChecker._internal();

  static InternetChecker getInstance() => _singleton;

  late bool hasConnection;

  late StreamSubscription<InternetConnectionStatus> listener;

  Future<void> dispose() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    await listener.cancel();
  }

  _checkInternetConnection(InternetConnectionStatus status) async {
    hasConnection = await InternetConnectionChecker().hasConnection;
    switch (status) {
      case InternetConnectionStatus.connected:
        hasConnection = true;
        break;
      case InternetConnectionStatus.disconnected:
        hasConnection = false;
        break;
    }
  }

  Future<void> checker() async {
    listener = InternetConnectionChecker()
        .onStatusChange
        .listen(_checkInternetConnection);

    await dispose();
  }
}

class ConnectionUtil {
  static final ConnectionUtil _singleton = ConnectionUtil._internal();
  ConnectionUtil._internal();

  static ConnectionUtil getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController();

  final Connectivity _connectivity = Connectivity();
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  void _connectionChange(ConnectivityResult result) {
    _hasInternetInternetConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;
  Future<bool> _hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // this is the different
      if (await InternetConnectionChecker().hasConnection) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } else {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
