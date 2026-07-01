import 'package:intl/intl.dart';

class DateUtils {
  DateUtils._();

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('yyyy年M月').format(date);
  }

  static String monthKey(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    const weekdays = ['', '一', '二', '三', '四', '五', '六', '日'];
    return weekdays[date.weekday];
  }

  static String formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return '今天';
    if (diff == -1) return '昨天';
    if (diff == -2) return '前天';
    if (diff == 1) return '明天';
    if (diff == 2) return '后天';
    return '${date.month}月${date.day}日';
  }

  static String formatWeekday(DateTime date) {
    return '周${formatDayOfWeek(date)}';
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static int daysInMonth(DateTime date) {
    return lastDayOfMonth(date).day;
  }

  static int firstWeekday(DateTime date) {
    return firstDayOfMonth(date).weekday % 7;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
}
