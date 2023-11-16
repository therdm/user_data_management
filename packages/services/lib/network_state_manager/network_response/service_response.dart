export '../extensions/response_to_map.dart';

part 'service_status.dart';

///This class is for returning Entity class as [body] and NetworkStatus as [status]
///from the RemoteDaos to the Use Cases or the controller
class ServiceResponse<T> {
  ///this constructor is to be used by outside world to construct
  ///a object of [ServiceResponse] class by supplying
  ///[status] of type [ServiceStatus] and [body] of type [T]
  const ServiceResponse({
    required this.status,
    required this.body,
  });

  const ServiceResponse.success({
    required this.body,
  }) : status = const ServiceStatus.success();

  const ServiceResponse.networkError({
    required this.body,
  }) : status = const ServiceStatus.networkError();

  ServiceResponse.dbError({
    this.body,
    String? message,
  }) : status = ServiceStatus.dbError(message: message ?? 'Database Error');

  ///this constructor is to construct a object of [ServiceResponse]
  ///class by supplying [body] of type [T] and [status] is set up as NO INTERNET
  ServiceResponse.offline({
    required this.body,
  }) : status = const ServiceStatus.noInternet();

  ///this is to store the status of a api call when its executed
  final ServiceStatus status;

  ///this is to catch the api response as json and convert it to RichData([T] : Entity class)
  final T? body;

// factory NetworkResponse.fromResponse({required Response response}) {
//   dynamic x = T;
//   return NetworkResponse(status: response.status, body: x.fromJson(response.body!));
// }
}
