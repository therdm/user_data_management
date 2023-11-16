import 'package:services/extensions/extension_int.dart';

extension ExtensionDateTime on DateTime {
  String toUtcTimeStampSSS() {
    final dateTime = toUtc().toIso8601String();
    return '${dateTime.substring(0, dateTime.length - 4)}Z';
  }

  String toYYYYMMDD() {
    return '$year-${month.tryDoubleDigit()}-${day.tryDoubleDigit()}';
  }

  String toDDMMYYYY() {
    return '${day.tryDoubleDigit()}/${month.tryDoubleDigit()}/$year';
  }

  String toYYYYMMDDHHMMXM() {
    return '$year-${month.tryDoubleDigit()}-${day.tryDoubleDigit()}'
        ' ${(hour <= 12 ? hour : (hour - 12)).tryDoubleDigit()}:${minute.tryDoubleDigit()}'
        ' ${hour < 12 ? 'AM' : 'PM'}';
  }
}
