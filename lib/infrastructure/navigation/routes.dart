part of 'navigation.dart';

class Routes {
  Routes._(this.context);

  factory Routes.of(BuildContext context) => Routes._(context);
  final BuildContext context;

  void toLocationHomeModule() => context.pushReplacement('/${RoutePath.homeModule}');

  void toLocationUserDetails(String id, String uuid, String fName, String lName, String uName, String pWord,
          String email, String ip, String macAdd, String webSite, String image) =>
      context.go(
          '/${RoutePath.homeModule}/${RoutePath.userDetails}?id=$id&uuid=$uuid&fName=$fName&lName=$lName&uName=$uName&pWord=$pWord&email=$email&ip=$ip&macAdd=$macAdd&webSite=$webSite&image=$image');

  void toInitializer() => context.go('/');
}

class RoutePath {
  static const initializer = '/';
  static const homeModule = 'home_module';
  static const userDetails = 'user_details';
}
