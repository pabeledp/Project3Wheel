enum PaymentStatus { paid, due, unpaid, off }

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

  CollectionModel({
    String? collectionId,
    String? id,
    DateTime? collectionDate,
    DateTime? date,
    required this.rickshawId,
    required this.driverId,
    required this.driverName,
    double? expectedRentRate,
    double? expectedAmount,
    required this.paidAmount,
    double? remainingDue,
    double? dueAmount,
    this.garageRent = 100.0,
    PaymentStatus? status,
    PaymentStatus? paymentStatus,
    String? recordedByUserId,
    String? recordedBy,
    this.isSynced = false,
    DateTime? createdAt,
  })  : collectionId = collectionId ?? id ?? '',
        collectionDate = collectionDate ?? date ?? createdAt ?? DateTime.now(),
        expectedRentRate = expectedRentRate ?? expectedAmount ?? 350.0,
        remainingDue = remainingDue ?? dueAmount ?? 0.0,
        status = status ?? paymentStatus ?? PaymentStatus.paid,
        recordedByUserId = recordedByUserId ?? recordedBy ?? '',
        createdAt = createdAt ?? DateTime.now();

  // Aliases for compatibility
  String get id => collectionId;
  DateTime get date => collectionDate;
  double get expectedAmount => expectedRentRate;
  double get dueAmount => remainingDue;
  PaymentStatus get paymentStatus => status;
  String get recordedBy => recordedByUserId;

  bool get isFullyPaid => status == PaymentStatus.paid;
  bool get isFullPaid => status == PaymentStatus.paid;
  bool get hasPartialDue => status == PaymentStatus.due;

  CollectionModel copyWith({
    String? collectionId,
    DateTime? collectionDate,
    String? rickshawId,
    String? driverId,
    String? driverName,
    double? expectedRentRate,
    double? paidAmount,
    double? remainingDue,
    double? garageRent,
    PaymentStatus? status,
    String? recordedByUserId,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return CollectionModel(
      collectionId: collectionId ?? this.collectionId,
      collectionDate: collectionDate ?? this.collectionDate,
      rickshawId: rickshawId ?? this.rickshawId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      expectedRentRate: expectedRentRate ?? this.expectedRentRate,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingDue: remainingDue ?? this.remainingDue,
      garageRent: garageRent ?? this.garageRent,
      status: status ?? this.status,
      recordedByUserId: recordedByUserId ?? this.recordedByUserId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      collectionId: map['collection_id'] as String? ?? map['id'] as String? ?? '',
      collectionDate: map['collection_date'] != null
          ? DateTime.tryParse(map['collection_date'].toString()) ?? DateTime.now()
          : (map['date'] != null ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now() : DateTime.now()),
      rickshawId: map['rickshaw_id'] as String? ?? '',
      driverId: map['driver_id'] as String? ?? '',
      driverName: map['driver_name'] as String? ?? '',
      expectedRentRate: (map['expected_rent_rate'] as num?)?.toDouble() ?? (map['expectedAmount'] as num?)?.toDouble() ?? 350.0,
      paidAmount: (map['paid_amount'] as num?)?.toDouble() ?? (map['paid'] as num?)?.toDouble() ?? 0.0,
      remainingDue: (map['remaining_due'] as num?)?.toDouble() ?? (map['dueAmount'] as num?)?.toDouble() ?? 0.0,
      garageRent: (map['garage_rent'] as num?)?.toDouble() ?? 100.0,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'] || e.name == map['paymentStatus'],
        orElse: () => PaymentStatus.paid,
      ),
      recordedByUserId: map['recorded_by_user_id'] as String? ?? map['recordedBy'] as String? ?? '',
      isSynced: map['is_synced'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
