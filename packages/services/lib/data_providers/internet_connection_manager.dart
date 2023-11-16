import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:reactiv/reactiv.dart';

class InternetConnectionManager {
  InternetConnectionManager._();

  static final InternetConnectionManager instance = InternetConnectionManager._();

  bool get isInternetConnected => _isInternetConnected.value;

  bool get isOffline => !_isInternetConnected.value;

  ///I am a private variable so that outside world cannot manipulate me
  final ReactiveBool _isInternetConnected = false.reactiv;

  void initialize() {
    listener((bool internetStatus) {
      if (internetStatus) {
        /// I am connected to a mobile or wifi network.
        _isInternetConnected.value = true;
      } else {
        /// I am NOT connected to a network.
        _isInternetConnected.value = false;
      }
    });
  }

  void listener(
    void Function(bool) onConnection, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult event) {
        if (event == ConnectivityResult.mobile) {
          /// I am connected to a mobile network.
          onConnection(true);
        } else if (event == ConnectivityResult.wifi) {
          /// I am connected to a wifi network.
          onConnection(true);
        } else {
          /// I am NOT connected to a network.
          onConnection(false);
        }
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void rawListener(
    void Function(ConnectivityResult) onConnection, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    Connectivity().onConnectivityChanged.listen(
          onConnection,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }
}
