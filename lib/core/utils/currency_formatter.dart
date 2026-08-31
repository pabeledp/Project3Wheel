import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _bdtFormat = NumberFormat.currency(
    symbol: '৳',
    decimalDigits: 0,
    locale: 'en_IN',
  );

  static final NumberFormat _bdtDecimalFormat = NumberFormat.currency(
    symbol: '৳',
    decimalDigits: 2,
    locale: 'en_IN',
  );

  /// Format as ৳1,250
  static String formatBDT(num amount) {
    return _bdtFormat.format(amount).replaceAll(' ', '');
  }

  /// Format as ৳1,250.50
  static String formatBDTWithDecimals(num amount) {
    return _bdtDecimalFormat.format(amount).replaceAll(' ', '');
  }

  /// Format with Bangla Numerals: e.g. ৳১,২৫০
  static String formatBanglaDigits(num amount) {
    const englishToBangla = {
      '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪',
      '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯',
    };
    final formatted = formatBDT(amount);
    return formatted.split('').map((char) => englishToBangla[char] ?? char).join();
  }
}
