import 'package:intl/intl.dart';

/// Formats a [DateTime] relative to the current time.
///
/// Returns:
/// - 'Agora' if less than 1 minute ago
/// - 'Xmin atrás' if less than 1 hour ago
/// - 'Xh atrás' if less than 1 day ago
/// - 'Xd atrás' if less than 7 days ago
/// - 'dd/MM/yyyy' otherwise
///
/// Returns empty string when [date] is null.
String formatDateTime(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays > 7) {
    return DateFormat('dd/MM/yyyy').format(date);
  } else if (diff.inDays > 0) {
    return '${diff.inDays}d atrás';
  } else if (diff.inHours > 0) {
    return '${diff.inHours}h atrás';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes}min atrás';
  } else {
    return 'Agora';
  }
}
