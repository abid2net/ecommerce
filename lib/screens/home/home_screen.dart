import 'package:ecommerce/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/widgets/global_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: Center(child: Text('Welcome, ${state.user.email}!')),
          );
        }
        return const GlobalLoading();
      },
    );
  }
}
