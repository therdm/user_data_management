import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactiv/reactiv.dart';
import 'package:user_data_assignment/infrastructure/navigation/navigation.dart';
import 'package:user_data_assignment/presentation/initializer/controllers/initializer.controller.dart';

class InitializerScreen extends ReactiveStateWidget<InitializerController> {
  const InitializerScreen({super.key, required this.state});

  @override
  BindController<InitializerController>? bindController() {
    return BindController(controller: () => InitializerController(), autoDispose: true);
  }

  final GoRouterState state;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (state.location == '/') {
        Routes.of(context).toLocationHomeModule();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}
