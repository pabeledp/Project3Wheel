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
              uid: '',
              name: '',
              garageName: 'My Electric Garage',
              role: UserRole.owner,
              phone: '',
            ),
            isAuthenticated: false,
          ),
        );

  void switchRole(UserRole role) {
    state = state.copyWith(
      currentUser: state.currentUser.copyWith(role: role),
    );
  }

  void setUser(UserModel user) {
    state = state.copyWith(
      currentUser: user,
      isAuthenticated: true,
    );
  }

  void updateProfile({required String name, required String garageName, required String phone}) {
    final updated = state.currentUser.copyWith(
      name: name,
      garageName: garageName,
      phone: phone,
    );
    state = state.copyWith(currentUser: updated);
  }

  void signOut() {
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
