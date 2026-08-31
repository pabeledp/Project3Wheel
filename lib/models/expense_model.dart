enum ExpenseCategory { mechanic, parts, rent, line_fee, other }

class ExpenseModel {
  final String id;
  final DateTime date;
  final ExpenseCategory category;
  final double amount;
  final String? receiptImageUrl;
  final String note;
  final String recordedBy;
  final bool isSynced;
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    this.receiptImageUrl,
    required this.note,
    required this.recordedBy,
    this.isSynced = false,
    required this.createdAt,
  });

  String get categoryDisplayName {
    switch (category) {
      case ExpenseCategory.mechanic:
        return 'Mechanic & Labor';
      case ExpenseCategory.parts:
        return 'Spare Parts & Battery';
      case ExpenseCategory.rent:
        return 'Garage Rent & Power';
      case ExpenseCategory.line_fee:
        return 'Line / Union Fee';
      case ExpenseCategory.other:
        return 'Miscellaneous';
    }
  }

  ExpenseModel copyWith({
    String? id,
    DateTime? date,
    ExpenseCategory? category,
    double? amount,
    String? receiptImageUrl,
    String? note,
    String? recordedBy,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      note: note ?? this.note,
      recordedBy: recordedBy ?? this.recordedBy,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'category': category.name,
      'amount': amount,
      'receipt_image_url': receiptImageUrl,
      'note': note,
      'recorded_by': recordedBy,
      'is_synced': isSynced,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    final catStr = map['category'] as String? ?? 'other';
    ExpenseCategory cat;
    switch (catStr) {
      case 'mechanic':
        cat = ExpenseCategory.mechanic;
        break;
      case 'parts':
        cat = ExpenseCategory.parts;
        break;
      case 'rent':
        cat = ExpenseCategory.rent;
        break;
      case 'line_fee':
        cat = ExpenseCategory.line_fee;
        break;
      default:
        cat = ExpenseCategory.other;
    }

    return ExpenseModel(
      id: map['id'] as String? ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      category: cat,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      receiptImageUrl: map['receipt_image_url'] as String?,
      note: map['note'] as String? ?? '',
      recordedBy: map['recorded_by'] as String? ?? 'manager',
      isSynced: map['is_synced'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
