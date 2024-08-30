import 'package:doantotnghiep/config/router.dart';
import 'package:doantotnghiep/features/auth/bloc/auth_bloc.dart';
import 'package:doantotnghiep/utils/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            FilledButton(
              onPressed: () => _handleLogout(context),
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );

    widget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthLogoutSuccess():
            context.pushReplacement(RouteName.login);
            context.read<AuthBloc>().add(AuthStarted());
            break;
          case AuthLogoutFailure(message: final msg):
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout Failure'),
                    content: Text(msg),
                    backgroundColor: context.color.surface,
                  );
                });
          default:
        }
      },
      child: widget,
    );

    return widget;
  }
}
