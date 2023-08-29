import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_imgur_app/services/constants.dart';

import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final FlutterAppAuth _appAuth =
      const FlutterAppAuth(); // Use the correct package name
  final baseUrl = 'https://api.imgur.com/oauth2/token';

  Dio dio = Dio();

  /// Since 'Too many requests' error was coming while
  /// trying to get accessToken, so had to make the
  /// AuthStatus to AuthStatus.authenticated.
  // AuthBloc() : super(AuthState(status: AuthStatus.initial));

  AuthBloc() : super(AuthState(status: AuthStatus.authenticated));

  //below method is not called, due to authenticaion issue.
  void authenticateWithImgur() async {
    try {
      final AuthorizationTokenResponse? response = // Use the correct type
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          kClientId,
          kRedirectUrl,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: 'https://api.imgur.com/oauth2/authorize',
            tokenEndpoint: 'https://api.imgur.com/oauth2/token',
          ),
        ),
      );

      String accessToken = response!.accessToken ?? '';
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        accessToken: accessToken,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}
