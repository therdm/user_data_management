import 'package:reactiv/reactiv.dart';
import 'package:services/network_state_manager/network_response/service_response.dart';

export 'package:reactiv/state_management/reactive_types.dart';
export 'package:services/network_state_manager/network_response/service_response.dart';


///This enum is for Network State of a particular api call
///states are => notStarted, loading, error, noInternet, success
enum ServiceState { notStarted, loading, error, noInternet, success }

mixin ServiceStateMixin {
  final Reactive<ServiceStatus> serviceStatus = Reactive<ServiceStatus>(const ServiceStatus.success());
  final Reactive<ServiceState> serviceState = Reactive<ServiceState>(ServiceState.notStarted);

  Future<ServiceStatus> serviceObserver(Future<ServiceStatus> Function() observer) {
    return _letsObserveAndChangeStateAndStatus(observer, serviceStatus, serviceState);
  }
}


Future<ServiceStatus> _letsObserveAndChangeStateAndStatus(
    Future<ServiceStatus> Function() observer,
    Reactive<ServiceStatus> serviceStatus,
    Reactive<ServiceState> serviceState,
    ) async {
  serviceState.value = ServiceState.loading;
  serviceStatus.value = await observer();
  if (!serviceStatus.value.isError) {
    serviceState.value = ServiceState.success;
  } else if (serviceStatus.value.isOffline) {
    serviceState.value = ServiceState.noInternet;
  } else {
    serviceState.value = ServiceState.error;
  }
  return serviceStatus.value;
}

Future<void> _letsResetStateAndStatus(
    Reactive<ServiceStatus> networkStatus,
    Reactive<ServiceState> networkState,
    ) async {
  networkState.value = ServiceState.notStarted;
  networkStatus.value = const ServiceStatus.success();
}