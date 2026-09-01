import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../services/storage/hive_service.dart';

class AuthState {
  final UserModel currentUser;
  final bool isAuthenticated;

  const AuthState({
    required this.currentUser,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? currentUser,
    bool? isAuthenticated,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final HiveService _hive = HiveService();

  AuthNotifier()
      : super(
          const AuthState(
            currentUser: UserModel(
              uid: '',
              name: '',
              garageName: 'My Electric Garage',
              role: UserRole.owner,
              phone: '',
            ),
            isAuthenticated: false,
          ),
        ) {
    _restoreSavedSession();
  }

  void _restoreSavedSession() {
    try {
      final savedMap = _hive.getActiveSession();
      if (savedMap != null && savedMap.isNotEmpty) {
        final user = UserModel.fromMap(savedMap);
        if (user.uid.isNotEmpty) {
          state = AuthState(
            currentUser: user,
            isAuthenticated: true,
          );
        }
      }
    } catch (_) {}
  }

  void switchRole(UserRole role) {
    final updated = state.currentUser.copyWith(role: role);
    state = state.copyWith(currentUser: updated);
    _hive.saveActiveSession(updated.toMap());
  }

  void setUser(UserModel user) {
    state = state.copyWith(
      currentUser: user,
      isAuthenticated: true,
    );
    _hive.saveActiveSession(user.toMap());
  }

  void updateProfile({required String name, required String garageName, required String phone}) {
    final updated = state.currentUser.copyWith(
      name: name,
      garageName: garageName,
      phone: phone,
    );
    state = state.copyWith(currentUser: updated);
    _hive.saveActiveSession(updated.toMap());
  }

  void signOut() {
    _hive.clearActiveSession();
    state = state.copyWith(
      currentUser: const UserModel(
        uid: '',
        name: '',
        garageName: '',
        role: UserRole.owner,
        phone: '',
      ),
      isAuthenticated: false,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
