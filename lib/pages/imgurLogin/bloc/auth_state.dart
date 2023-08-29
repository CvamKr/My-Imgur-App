import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_appauth/flutter_appauth.dart'; // Import the correct package
import 'package:equatable/equatable.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String accessToken;

  AuthState({
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

class AuthCubit extends Cubit<AuthState> {
  final FlutterAppAuth _appAuth = FlutterAppAuth(); // Use the correct package name

  AuthCubit() : super(AuthState(status: AuthStatus.initial));

  void authenticateWithImgur() async {
    try {
      final AuthorizationTokenResponse? response = // Use the correct type
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'YOUR_CLIENT_ID',
          'YOUR_REDIRECT_URI',
          issuer: 'https://api.imgur.com/oauth2/authorize',
          scopes: ['public'],
        ),
      );

      String accessToken = response!.accessToken ?? '';
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        accessToken: accessToken,
      ));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}
