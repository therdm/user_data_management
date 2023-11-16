//
// enum LocalDbOpStatus{
//   error, success;
//
//   bool get isSuccess => this == LocalDbOpStatus.success;
//   bool get isError => this == LocalDbOpStatus.error;
// }
//
// class LocalResponse<T> {
//
//   ///this constructor is to be used by outside world to construct
//   ///a object of [LocalResponse] class by supplying
//   ///[status] of type [LocalDbOpStatus] and [body] of type [T]
//   const LocalResponse({
//     required this.status,
//     required this.body,
//   });
//
//   ///this is to store the status of a local db call when its executed
//   final LocalDbOpStatus status;
//
//   ///this is to catch the local db json response as json
//   ///and convert it to RichData([T] : Entity class)
//   final T? body;
// }
//
//
