import 'package:flutter/material.dart';

import 'package:services/network_state_manager/network_state/service_state_manager.dart';
import 'package:services/network_widgets/network_state_view.dart';

class BackDropNetworkStateView extends StatelessWidget {
  const BackDropNetworkStateView({
    super.key,
    required this.child,
    required this.loadingWidget,
    required this.networkState,
  });

  final Widget child;
  final ServiceState networkState;
  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        NetworkStateView.sizeFree(
          networkState: networkState,
          loadingWidget: loadingWidget,
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
