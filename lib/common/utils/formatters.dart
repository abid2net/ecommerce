import 'package:ecommerce/common/constants/app_constants.dart';
import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormatter = NumberFormat.currency(
    symbol: AppConstants.currency,
    decimalDigits: 2,
  );

  static final _dateFormatter = DateFormat('MMM dd, yyyy');
  static final _timeFormatter = DateFormat('hh:mm a');

  static String formatPrice(double price) {
    return _currencyFormatter.format(price);
  }

  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return '${_dateFormatter.format(dateTime)} ${_timeFormatter.format(dateTime)}';
  }
}
