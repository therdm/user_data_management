import 'package:services/data_providers/data_providers.dart';
import 'package:user_data_assignment/infrastructure/environment/app_environment.dart';

Future<void> initializeApp() async {
  AppEnvironment.setCurrentEnvironment(
    AppEnvironment.dummy,
    showLog: true,
  );
  InternetConnectionManager.instance.initialize();
  await LocalStorage.instance.initialize();
  RestApi.instance.initialize(
    baseUrl: AppEnvironment.currentEnv.url,
    showApiLog: true,
    apiVersion: AppEnvironment.currentEnv.apiVersion,
  );
}
