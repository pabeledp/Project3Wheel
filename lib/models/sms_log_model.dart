enum SmsStatus { sent, failed, pending }

class SmsLogModel {
  final String logId;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String message;
  final DateTime timestamp;
  final SmsStatus status;
  final String? responseInfo;

  const SmsLogModel({
    required this.logId,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.message,
    required this.timestamp,
    required this.status,
    this.responseInfo,
  });

  bool get isSuccess => status == SmsStatus.sent;

  Map<String, dynamic> toMap() {
    return {
      'log_id': logId,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'response_info': responseInfo,
    };
  }

  factory SmsLogModel.fromMap(Map<String, dynamic> map) {
    final statusStr = map['status'] as String? ?? 'pending';
    SmsStatus s;
    switch (statusStr) {
      case 'sent':
        s = SmsStatus.sent;
        break;
      case 'failed':
        s = SmsStatus.failed;
        break;
      default:
        s = SmsStatus.pending;
    }

    return SmsLogModel(
      logId: map['log_id'] as String? ?? '',
      driverId: map['driver_id'] as String? ?? '',
      driverName: map['driver_name'] as String? ?? '',
      driverPhone: map['driver_phone'] as String? ?? '',
      message: map['message'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: s,
      responseInfo: map['response_info'] as String?,
    );
  }
}
