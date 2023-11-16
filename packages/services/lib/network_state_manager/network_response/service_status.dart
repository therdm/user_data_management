part of 'service_response.dart';

///This class is a custom Network Status, this will store only the status parameters we will need
class ServiceStatus {
  ///This constructor sets status according to the parameter passed
  ///both [statusCode] and [message] variables are required
  ///and isError is calculated according to the statusCode
  const ServiceStatus({
    required this.statusCode,
    required this.message,
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = statusCode == 502;

  const ServiceStatus.networkError({
    this.statusCode = 500,
    this.message = 'Something Went Wrong',
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = false;

  const ServiceStatus.dbError({
    this.statusCode = 5002,
    this.message = 'Something Went Wrong',
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = false;

  ///This constructor sets initially the [statusCode] to be 200,
  ///i.e, success if no parameter is passed
  const ServiceStatus.success({
    this.statusCode = 200,
    this.message = 'success',
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = false;

  ///This constructor sets  the [statusCode] to be 502,
  ///i.e, no internet if no parameter is passed
  const ServiceStatus.noInternet({
    this.statusCode = 502,
    this.message = 'no_internet',
  })  : isError = true,
        isOffline = true;

  ///this is the status code got from the network call
  final int statusCode;

  ///this is the status message got from the network call
  final String message;

  ///this is the status of the network call whether it is an Error or Not
  final bool isError;



  bool get isSuccess => !isError;
  bool get isAuthError => statusCode == 401;
  bool get isServerDown => statusCode == 503;

  ///this is the status of the network call whether it is for no internet or not
  final bool isOffline;
}
