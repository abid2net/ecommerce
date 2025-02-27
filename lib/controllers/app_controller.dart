import 'package:ecommerce/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_state.dart';
import 'package:ecommerce/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/common/widgets/custom_loading.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/routes/routes.dart';
import 'package:ecommerce/screens/main/customer_layout_screen.dart';
import 'package:ecommerce/screens/main/admin_layout_screen.dart';

class AppController extends StatelessWidget {
  const AppController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const CustomLoadingIndicator(isFullScreen: true);
        }

        if (state is Authenticated) {
          return buildHomeScreen(state.user);
        }

        return const LoginScreen();
      },
    );
  }

  Widget buildHomeScreen(UserModel user) {
    return user.isAdmin
        ? const AdminLayoutScreen()
        : const CustomerLayoutScreen();
  }

  void navigateToInitialScreen(BuildContext context, UserModel user) {
    final route = user.isAdmin ? Routes.productManagement : Routes.home;

    Navigator.pushReplacementNamed(context, route);
  }
}
