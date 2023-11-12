import 'package:intl/intl.dart';

class CommonFunctions {
  static String formatDateFromDateTime(DateTime time) {
    return DateFormat('dd-MM-yyy HH:mm:ss').format(time);
  }

  static String formatDateFromString(String time) {
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(time));
  }

  static String formatTimeFromString(String time) {
    return DateFormat('HH:mm:ss').format(DateTime.parse(time));
  }

  static String formatTimeFromDuration(Duration time) {
    return DateFormat('HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(time.inMilliseconds));
  }
}
