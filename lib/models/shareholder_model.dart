class ShareholderModel {
  final String id;
  final String name;
  final String phone;
  final double equity; // percentage e.g. 25.0
  final double investment; // total capital e.g. 500000
  final String rickshaws; // assigned units e.g. 'R-01, R-02'
  final String joinDate;

  const ShareholderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.equity,
    required this.investment,
    this.rickshaws = '',
    required this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'equity': equity,
      'investment': investment,
      'rickshaws': rickshaws,
      'joinDate': joinDate,
    };
  }

  factory ShareholderModel.fromMap(Map<String, dynamic> map) {
    return ShareholderModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      equity: (map['equity'] as num?)?.toDouble() ?? 0.0,
      investment: (map['investment'] as num?)?.toDouble() ?? 0.0,
      rickshaws: map['rickshaws']?.toString() ?? '',
      joinDate: map['joinDate']?.toString() ?? '',
    );
  }

  ShareholderModel copyWith({
    String? id,
    String? name,
    String? phone,
    double? equity,
    double? investment,
    String? rickshaws,
    String? joinDate,
  }) {
    return ShareholderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      equity: equity ?? this.equity,
      investment: investment ?? this.investment,
      rickshaws: rickshaws ?? this.rickshaws,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
