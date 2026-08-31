enum PaymentStatus { paid, due, unpaid }

class CollectionModel {
  final String collectionId;
  final DateTime collectionDate;
  final String rickshawId;
  final String driverId;
  final String driverName;
  final double expectedRentRate;
  final double paidAmount;
  final double remainingDue;
  final double garageRent;
  final PaymentStatus status;
  final String recordedByUserId;
  final bool isSynced;
  final DateTime createdAt;

  const CollectionModel({
    required this.collectionId,
    required this.collectionDate,
    required this.rickshawId,
    required this.driverId,
    required this.driverName,
    required this.expectedRentRate,
    required this.paidAmount,
    required this.remainingDue,
    this.garageRent = 100.0,
    required this.status,
    required this.recordedByUserId,
    this.isSynced = false,
    required this.createdAt,
  });

  bool get isFullyPaid => status == PaymentStatus.paid;

  Map<String, dynamic> toMap() {
    return {
      'collection_id': collectionId,
      'collection_date': collectionDate.toIso8601String(),
      'rickshaw_id': rickshawId,
      'driver_id': driverId,
      'driver_name': driverName,
      'expected_rent_rate': expectedRentRate,
      'paid_amount': paidAmount,
      'remaining_due': remainingDue,
      'garage_rent': garageRent,
      'status': status.name,
      'recorded_by_user_id': recordedByUserId,
      'is_synced': isSynced,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      collectionId: map['collection_id'] as String? ?? '',
      collectionDate: map['collection_date'] != null
          ? DateTime.tryParse(map['collection_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      rickshawId: map['rickshaw_id'] as String? ?? '',
      driverId: map['driver_id'] as String? ?? '',
      driverName: map['driver_name'] as String? ?? '',
      expectedRentRate: (map['expected_rent_rate'] as num?)?.toDouble() ?? 350.0,
      paidAmount: (map['paid_amount'] as num?)?.toDouble() ?? 0.0,
      remainingDue: (map['remaining_due'] as num?)?.toDouble() ?? 0.0,
      garageRent: (map['garage_rent'] as num?)?.toDouble() ?? 100.0,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PaymentStatus.paid,
      ),
      recordedByUserId: map['recorded_by_user_id'] as String? ?? '',
      isSynced: map['is_synced'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
