import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('EEEE d MMMM yyyy • HH:mm').format(dateTime);
}
