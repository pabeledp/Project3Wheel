import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';

class AuthState {
  final UserModel currentUser;
  final bool isAuthenticated;

  const AuthState({
    required this.currentUser,
    this.isAuthenticated = true,
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
  AuthNotifier()
      : super(
          const AuthState(
            currentUser: UserModel(
              uid: 'OWNER-001',
              name: 'Habib Rahman',
              role: UserRole.owner,
              phone: '01710001122',
            ),
            isAuthenticated: false,
          ),
        );

  void switchRole(UserRole role) {
    if (role == UserRole.owner) {
      state = state.copyWith(
        currentUser: const UserModel(
          uid: 'OWNER-001',
          name: 'Habib Rahman',
          role: UserRole.owner,
          phone: '01710001122',
        ),
      );
    } else {
      state = state.copyWith(
        currentUser: const UserModel(
          uid: 'MGR-SELIM',
          name: 'Selim Mia',
          role: UserRole.manager,
          phone: '01815556677',
        ),
      );
    }
  }

  void setUser(UserModel user) {
    state = state.copyWith(currentUser: user, isAuthenticated: true);
  }

  void signOut() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
