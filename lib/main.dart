import 'dart:io';
import 'package:flutter/material.dart';
import 'package:user_data_assignment/infrastructure/navigation/navigation.dart';
import 'package:user_data_assignment/infrastructure/theme/theme.dart';
import 'package:user_data_assignment/initialize_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Nav.goRoutes,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light(),
      themeMode: ThemeMode.light,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
