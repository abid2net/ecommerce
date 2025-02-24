import 'package:ecommerce/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_state.dart';
import 'package:ecommerce/screens/auth/login_screen.dart';
import 'package:ecommerce/screens/main/main_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/widgets/global_loading.dart';

class AppController extends StatelessWidget {
  const AppController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const GlobalLoading();
        }

        if (state is Authenticated) {
          return const MainLayoutScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
