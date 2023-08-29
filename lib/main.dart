import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_imgur_app/pages/displayImage/ui/display_image.dart';
import 'package:my_imgur_app/pages/imgurLogin/bloc/auth_bloc.dart';

import 'pages/displayImage/bloc/display_images_bloc.dart';
import 'pages/imgurLogin/bloc/auth_state.dart';
import 'pages/imgurLogin/ui/imgur_login_page.dart';
import 'pages/imgurLogin/ui/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Imgur App',
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return BlocProvider(
                  create: (context) => DisplayImagesBloc(),
                  child: const DisplayImagesPage());
            } else if (state.status == AuthStatus.unauthenticated) {
              return const ImgurLoginPage();
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
