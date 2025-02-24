import 'package:ecommerce/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/auth_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'controllers/app_controller.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create:
            (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
        child: MaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          home: const AppController(),
        ),
      ),
    );
  }
}
