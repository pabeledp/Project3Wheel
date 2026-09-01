enum UserRole { owner, manager }

class UserModel {
  final String uid;
  final String name;
  final String garageName;
  final UserRole role;
  final String phone;
  final String? avatarUrl;

  const UserModel({
    required this.uid,
    required this.name,
    this.garageName = 'My Electric Garage',
    required this.role,
    required this.phone,
    this.avatarUrl,
  });

  bool get isOwner => role == UserRole.owner;
  bool get isManager => role == UserRole.manager;

  String get roleDisplayName => isOwner ? 'Fleet Owner' : 'Garage Manager';

  UserModel copyWith({
    String? uid,
    String? name,
    String? garageName,
    UserRole? role,
    String? phone,
    String? avatarUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      garageName: garageName ?? this.garageName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'garage_name': garageName,
      'role': role.name,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      garageName: map['garage_name'] as String? ?? map['garageName'] as String? ?? 'My Electric Garage',
      role: (map['role'] == 'owner') ? UserRole.owner : UserRole.manager,
      phone: map['phone'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
    );
  }
}
