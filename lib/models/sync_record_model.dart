enum SyncAction { create, update, delete }

class SyncRecordModel {
  final String id;
  final String collectionName;
  final SyncAction action;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final int retryCount;

  const SyncRecordModel({
    required this.id,
    required this.collectionName,
    required this.action,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
  });

  SyncRecordModel copyWith({
    String? id,
    String? collectionName,
    SyncAction? action,
    Map<String, dynamic>? payload,
    DateTime? timestamp,
    int? retryCount,
  }) {
    return SyncRecordModel(
      id: id ?? this.id,
      collectionName: collectionName ?? this.collectionName,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collection_name': collectionName,
      'action': action.name,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'retry_count': retryCount,
    };
  }

  factory SyncRecordModel.fromMap(Map<String, dynamic> map) {
    final actionStr = map['action'] as String? ?? 'create';
    SyncAction act;
    switch (actionStr) {
      case 'update':
        act = SyncAction.update;
        break;
      case 'delete':
        act = SyncAction.delete;
        break;
      default:
        act = SyncAction.create;
    }

    return SyncRecordModel(
      id: map['id'] as String? ?? '',
      collectionName: map['collection_name'] as String? ?? '',
      action: act,
      payload: Map<String, dynamic>.from(map['payload'] as Map? ?? {}),
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      retryCount: (map['retry_count'] as num?)?.toInt() ?? 0,
    );
  }
}
