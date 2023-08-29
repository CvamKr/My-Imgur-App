
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class ImgurLoginPage extends StatelessWidget {
  const ImgurLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              authBloc.authenticateWithImgur(),
          child: const Text('Authenticate with Imgur'),
        ),
      ),
    );
  }
}
