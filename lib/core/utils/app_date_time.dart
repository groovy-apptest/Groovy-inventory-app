import 'package:intl/intl.dart';

abstract final class AppDateTime {
  static const istOffset = Duration(hours: 5, minutes: 30);

  static DateTime parseUtcToIst(String value) {
    final utcValue = _hasTimezone(value) ? value : '${value}Z';
    return DateTime.parse(utcValue).toUtc().add(istOffset);
  }

  static DateTime? tryParseUtcToIst(dynamic value) {
    if (value == null) return null;
    return parseUtcToIst(value.toString());
  }

  static DateTime nowIst() => DateTime.now().toUtc().add(istOffset);

  static String formatTransactionDate(DateTime istDate) {
    final now = nowIst();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(istDate.year, istDate.month, istDate.day);
    final time = DateFormat('HH:mm').format(istDate);

    if (dateOnly == today) return 'Today · $time';
    if (dateOnly == yesterday) return 'Yesterday · $time';
    return '${DateFormat('dd MMM').format(istDate)} · $time';
  }

  static String formatDateTime(DateTime istDate) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(istDate);
  }

  static String timeAgo(DateTime istDate) {
    final diff = nowIst().difference(istDate);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    if (diff.inDays < 30) return '${diff.inDays} days ago';
    final months = diff.inDays ~/ 30;
    if (months < 12) return '$months month${months == 1 ? '' : 's'} ago';
    final years = diff.inDays ~/ 365;
    return '$years year${years == 1 ? '' : 's'} ago';
  }

  static bool _hasTimezone(String value) {
    return RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(value);
  }
}
