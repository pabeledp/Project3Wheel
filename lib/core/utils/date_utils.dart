import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _displayDate = DateFormat('dd MMM yyyy');
  static final DateFormat _displayDateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeOnly = DateFormat('hh:mm a');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');

  static String formatDate(DateTime date) => _displayDate.format(date);
  static String formatDateTime(DateTime date) => _displayDateTime.format(date);
  static String formatIsoDate(DateTime date) => _isoDate.format(date);
  static String formatTime(DateTime date) => _timeOnly.format(date);
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }
}
