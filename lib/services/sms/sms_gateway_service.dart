import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../models/sms_log_model.dart';
import '../storage/hive_service.dart';
import 'bangla_sms_templates.dart';

class SmsGatewayService {
  static final SmsGatewayService _instance = SmsGatewayService._internal();
  factory SmsGatewayService() => _instance;
  SmsGatewayService._internal();

  final HiveService _hive = HiveService();
  final Uuid _uuid = const Uuid();

  // Gateway Configurations
  String apiKey = 'DEMO_GREENWEB_API_KEY_3WHEEL';
  String token = 'DEMO_BDSMS_TOKEN_AUTH';
  String defaultEndpoint = 'https://api.greenweb.com.bd/api.php';
  bool isSimulationMode = true; // Can be toggled in settings

  /// Sends Due Reminder SMS to a driver
  Future<SmsLogModel> sendDueReminder({
    required String driverId,
    required String driverName,
    required String driverPhone,
    required double dueAmount,
    String? garagePhone,
  }) async {
    final message = BanglaSmsTemplates.dueReminder(
      driverName: driverName,
      dueAmount: dueAmount,
      contactPhone: garagePhone,
    );

    return sendSms(
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      message: message,
    );
  }

  /// Base SMS dispatcher with fallback handling
  Future<SmsLogModel> sendSms({
    required String driverId,
    required String driverName,
    required String driverPhone,
    required String message,
  }) async {
    final logId = 'SMS-${DateTime.now().millisecondsSinceEpoch}-${_uuid.v4().substring(0, 4)}';
    SmsStatus status = SmsStatus.pending;
    String? responseDetail;

    if (isSimulationMode) {
      // Simulate real-world network delay & successful dispatch
      await Future.delayed(const Duration(milliseconds: 650));
      status = SmsStatus.sent;
      responseDetail = 'Greenweb Mock Gateway: 200 OK, message_id=GW_${DateTime.now().millisecondsSinceEpoch}';
    } else {
      try {
        final response = await http.post(
          Uri.parse(defaultEndpoint),
          body: {
            'token': token,
            'to': _formatPhoneNumber(driverPhone),
            'message': message,
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          status = SmsStatus.sent;
          responseDetail = 'Response: ${response.body}';
        } else {
          status = SmsStatus.failed;
          responseDetail = 'HTTP ${response.statusCode}: ${response.body}';
        }
      } catch (e) {
        debugPrint('[SmsGatewayService] Dispatch error: $e');
        status = SmsStatus.failed;
        responseDetail = 'Network Error: $e';
      }
    }

    final log = SmsLogModel(
      logId: logId,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      message: message,
      timestamp: DateTime.now(),
      status: status,
      responseInfo: responseDetail,
    );

    await _hive.saveSmsLog(log);
    return log;
  }

  String _formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '88$cleaned';
    } else if (!cleaned.startsWith('880')) {
      cleaned = '880$cleaned';
    }
    return cleaned;
  }
}
