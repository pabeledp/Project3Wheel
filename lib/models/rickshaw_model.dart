enum RickshawStatus { active, maintenance }

class LastLocation {
  final double lat;
  final double lng;
  final double speed;
  final DateTime updatedAt;

  const LastLocation({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'speed': speed,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LastLocation.fromMap(Map<String, dynamic> map) {
    return LastLocation(
      lat: (map['lat'] as num?)?.toDouble() ?? 23.8103,
      lng: (map['lng'] as num?)?.toDouble() ?? 90.4125,
      speed: (map['speed'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class RickshawModel {
  final String rickshawId; // e.g. 'R-01'
  final String qrCode;
  final RickshawStatus status;
  final String deviceImei;
  final double dailyRentRate; // standard daily deposit (e.g. 350 BDT)
  final LastLocation lastLocation;
  final String? assignedDriverId;
  final String? modelName;

  const RickshawModel({
    required this.rickshawId,
    required this.qrCode,
    required this.status,
    required this.deviceImei,
    this.dailyRentRate = 350.0,
    required this.lastLocation,
    this.assignedDriverId,
    this.modelName = 'Mishuk Classic 48V',
  });

  bool get isActive => status == RickshawStatus.active;
  bool get isInMaintenance => status == RickshawStatus.maintenance;

  RickshawModel copyWith({
    String? rickshawId,
    String? qrCode,
    RickshawStatus? status,
    String? deviceImei,
    double? dailyRentRate,
    LastLocation? lastLocation,
    String? assignedDriverId,
    String? modelName,
  }) {
    return RickshawModel(
      rickshawId: rickshawId ?? this.rickshawId,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      deviceImei: deviceImei ?? this.deviceImei,
      dailyRentRate: dailyRentRate ?? this.dailyRentRate,
      lastLocation: lastLocation ?? this.lastLocation,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      modelName: modelName ?? this.modelName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rickshaw_id': rickshawId,
      'qr_code': qrCode,
      'status': status.name,
      'device_imei': deviceImei,
      'daily_rent_rate': dailyRentRate,
      'last_location': lastLocation.toMap(),
      'assigned_driver_id': assignedDriverId,
      'model_name': modelName,
    };
  }

  factory RickshawModel.fromMap(Map<String, dynamic> map) {
    return RickshawModel(
      rickshawId: map['rickshaw_id'] as String? ?? 'R-01',
      qrCode: map['qr_code'] as String? ?? 'R-01',
      status: (map['status'] == 'maintenance')
          ? RickshawStatus.maintenance
          : RickshawStatus.active,
      deviceImei: map['device_imei'] as String? ?? '864201048291001',
      dailyRentRate: (map['daily_rent_rate'] as num?)?.toDouble() ?? 350.0,
      lastLocation: map['last_location'] != null
          ? LastLocation.fromMap(Map<String, dynamic>.from(map['last_location'] as Map))
          : LastLocation(lat: 23.8103, lng: 90.4125, speed: 0.0, updatedAt: DateTime.now()),
      assignedDriverId: map['assigned_driver_id'] as String?,
      modelName: map['model_name'] as String? ?? 'Mishuk Classic 48V',
    );
  }
}
