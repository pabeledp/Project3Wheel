class DriverModel {
  final String driverId;
  final String name;
  final String phone;
  final String nid;
  final double agreedDailyRate;
  final double totalDue;
  final String? activeRickshawId;
  final String? avatarUrl;
  final String address;
  final DateTime joinedDate;

  const DriverModel({
    required this.driverId,
    required this.name,
    required this.phone,
    required this.nid,
    this.agreedDailyRate = 350.0,
    this.totalDue = 0.0,
    this.activeRickshawId,
    this.avatarUrl,
    this.address = 'Mirpur-10, Dhaka',
    required this.joinedDate,
  });

  // Aliases for compatibility
  String get id => driverId;
  double get due => totalDue;
  String? get activeRickshaw => activeRickshawId;
  DateTime get joinDate => joinedDate;

  bool get hasDue => totalDue > 0;

  DriverModel copyWith({
    String? driverId,
    String? name,
    String? phone,
    String? nid,
    double? agreedDailyRate,
    double? totalDue,
    String? activeRickshawId,
    String? avatarUrl,
    String? address,
    DateTime? joinedDate,
  }) {
    return DriverModel(
      driverId: driverId ?? this.driverId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nid: nid ?? this.nid,
      agreedDailyRate: agreedDailyRate ?? this.agreedDailyRate,
      totalDue: totalDue ?? this.totalDue,
      activeRickshawId: activeRickshawId ?? this.activeRickshawId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'name': name,
      'phone': phone,
      'nid': nid,
      'agreed_daily_rate': agreedDailyRate,
      'total_due': totalDue,
      'active_rickshaw_id': activeRickshawId,
      'avatar_url': avatarUrl,
      'address': address,
      'joined_date': joinedDate.toIso8601String(),
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      driverId: map['driver_id'] as String? ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      nid: map['nid'] as String? ?? '',
      agreedDailyRate: (map['agreed_daily_rate'] as num?)?.toDouble() ?? 350.0,
      totalDue: (map['total_due'] as num?)?.toDouble() ?? (map['due'] as num?)?.toDouble() ?? 0.0,
      activeRickshawId: map['active_rickshaw_id'] as String? ?? map['activeRickshaw'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      address: map['address'] as String? ?? 'Mirpur-10, Dhaka',
      joinedDate: map['joined_date'] != null
          ? DateTime.tryParse(map['joined_date'].toString()) ?? DateTime.now()
          : (map['joinDate'] != null ? DateTime.tryParse(map['joinDate'].toString()) ?? DateTime.now() : DateTime.now()),
    );
  }
}
