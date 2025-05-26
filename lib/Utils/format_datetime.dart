import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('EEEE d MMMM yyyy • HH:mm').format(dateTime);
}

String getCurrentFormattedMonth() {
  final now = DateTime.now();
  return DateFormat('MMMM yyyy', 'fr_FR').format(now);
}
