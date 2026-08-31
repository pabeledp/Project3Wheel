import '../../core/utils/currency_formatter.dart';

class BanglaSmsTemplates {
  BanglaSmsTemplates._();

  /// Formats personalized Due Reminder in Bengali
  static String dueReminder({
    required String driverName,
    required double dueAmount,
    String garageName = 'প্রজেক্ট ৩ হুইল গ্যারেজ',
    String? contactPhone,
  }) {
    final formattedDue = CurrencyFormatter.formatBanglaDigits(dueAmount);
    final contactSuffix = contactPhone != null ? ' প্রয়োজনে যোগাযোগ করুন: $contactPhone।' : '';
    return 'শ্রদ্ধেয় $driverName ভাই, $garageName-এ আপনার বকেয়া পাওনা $formattedDue টাকা। অনুগ্রহ করে দ্রুত পরিশোধ করুন।$contactSuffix ধন্যবাদ।';
  }

  /// Payment Received Confirmation in Bengali
  static String paymentConfirmation({
    required String driverName,
    required double paidAmount,
    required double remainingDue,
    String garageName = 'প্রজেক্ট ৩ হুইল গ্যারেজ',
  }) {
    final formattedPaid = CurrencyFormatter.formatBanglaDigits(paidAmount);
    final formattedRemaining = CurrencyFormatter.formatBanglaDigits(remainingDue);

    if (remainingDue <= 0) {
      return 'শ্রদ্ধেয় $driverName ভাই, আপনার $formattedPaid টাকা জমা হয়েছে। আপনার কোনো বকেয়া নেই। শুভ যাত্রা!';
    } else {
      return 'শ্রদ্ধেয় $driverName ভাই, আপনার $formattedPaid টাকা জমা হয়েছে। অবশিষ্ট বকেয়া $formattedRemaining টাকা। ধন্যবাদ।';
    }
  }

  /// Urgent Notice in Bengali
  static String urgentNotice({
    required String driverName,
    required String noticeMessage,
    String garageName = 'প্রজেক্ট ৩ হুইল গ্যারেজ',
  }) {
    return 'জরুরি বিজ্ঞপ্তি: শ্রদ্ধেয় $driverName ভাই, $garageName হতে জানানো যাচ্ছে যে, $noticeMessage। ধন্যবাদ।';
  }
}
