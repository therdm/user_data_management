import 'package:flutter/material.dart';
import 'package:services/network_state_manager/network_response/service_response.dart';
import 'package:services/network_state_manager/network_state/service_state_manager.dart';
import 'package:services/network_widgets/show_snackbar.dart';

///This class is for wrap-ing those widgets where some api call will be happening
///It is mandatory to Wrap this class Obx or run setState((){})
///when [networkState] is changed
///Then only this class will work in desired behaviour
class NetworkStateView extends StatelessWidget {
  ///This constructor is combination of
  ///NetworkStateView.fullScreenOnly & NetworkStateView.snackBarOnly
  ///i.e, when you wrap a view with this widget this will
  ///show error in snack-bar and in full screen as well
  const NetworkStateView({
    super.key,
    required this.networkState,
    required this.child,
    this.showNoInternetWarningOnly = false,
    this.loadingWidget,
    this.errorWidget,
    this.initialPlaceHolder,
    this.isExpanded = false,
  });

  ///This constructor is for showing error in full screen view
  ///this is useful when opening any screen and calling GET api
  ///and showing state in full Scaffold => Loading or No Internet or Something Went Wrong
  ///wrap that view with this widget and pass the same networkState coming from
  ///networkObserver of the NetworkStateMixin
  const NetworkStateView.fullScreenOnly({
    super.key,
    required this.networkState,
    required this.child,
    this.showNoInternetWarningOnly = false,
    this.loadingWidget,
    this.errorWidget,
    this.initialPlaceHolder,
    this.isExpanded = false,
  });

  const NetworkStateView.sizeFree({
    super.key,
    required this.networkState,
    required this.child,
    this.showNoInternetWarningOnly = false,
    this.loadingWidget,
    this.errorWidget,
    this.initialPlaceHolder,
  }) : isExpanded = false;

  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? initialPlaceHolder;

  final bool isExpanded;

  ///Let's say some api call is going on through a networkObserver then
  ///this variable will tell the widget tree
  ///what is the state of that api call : notStarted, loading, error, noInternet, success
  final ServiceState networkState;

  final bool showNoInternetWarningOnly;

  final Widget child;

  Widget buildChild() {
    switch (networkState) {
      case ServiceState.notStarted:
        return initialPlaceHolder ??
            (!isExpanded ? const NetworkErrorWidget(text: '') : const Scaffold(body: NetworkErrorWidget(text: '')));
      case ServiceState.loading:
        return loadingWidget ?? (!isExpanded ? const LoadingWidget() : const Scaffold(body: LoadingWidget()));
      case ServiceState.error:
        return errorWidget ?? (!isExpanded ? const NetworkErrorWidget() : const Scaffold(body: NetworkErrorWidget()));
      case ServiceState.noInternet:
        if (!showNoInternetWarningOnly) {
          return !isExpanded ? const Text('No Internet') : const NetworkErrorWidget(text: 'NO INTERNET CONNECTION');
        } else {
          return child;
        }
      case ServiceState.success:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isExpanded
        ? buildChild()
        : Scaffold(
            body: Column(
              children: [
                Expanded(child: buildChild()),
                if (showNoInternetWarningOnly)
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade600),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    child: const Text(
                      'You are offline',
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              const Text('Loading'),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    super.key,
    this.image,
    this.text,
  });

  final Widget? image;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (image != null) image!,
          Text(
            text ?? 'SOMETHING WENT WRONG',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, size: 32),
              SizedBox(height: 12),
              Text('No Data Found'),
            ],
          ),
        ),
      ),
    );
  }
}
