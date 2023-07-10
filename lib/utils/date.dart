import 'package:intl/intl.dart';

class Date {
  String getDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String today = formatter.format(now);
    return today;
  }
}