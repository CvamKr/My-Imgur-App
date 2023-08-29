import 'package:equatable/equatable.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String accessToken;

  const AuthState({
    required this.status,
    this.accessToken = '',
  });

  @override
  List<Object?> get props => [status, accessToken];

  AuthState copyWith({
    AuthStatus? status,
    String? accessToken,
  }) {
    return AuthState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
