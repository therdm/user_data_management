import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteErrorScreen extends StatelessWidget {
  /// Redirects to [RouteErrorScreen] when the specified route is not found
  const RouteErrorScreen({
    super.key,
    this.error,
    this.location = '/',
  });

  final Exception? error;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error!!')),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text('error: $error', textAlign: TextAlign.center),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => context.go(location),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
