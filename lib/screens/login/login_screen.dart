import 'package:doantotnghiep/utils/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components/single_child_scroll_view_with_column.dart';
import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _authState = context.read<AuthBloc>().state;

  late final _usernameController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(username: final username) => username,
      _ => ''
    }),
  );

  late final _passwordController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(password: final password) => password,
      _ => ''
    }),
  );

  void _handleGo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  _buildInitialLoginWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              autofillHints: const [AutofillHints.username],
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleGo(context);
              },
              label: const Text('Go'),
              icon: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.go(RouteName.register);
                context.read<AuthBloc>().add(AuthStarted());
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ]
              .animate(
                interval: 50.ms,
              )
              .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              )
              .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              ),
        ),
      ),
    );
  }

  _buildFailureLoginWidget(message) {
    return Column(children: [
      Text(
        message,
        style: context.text.bodyLarge!.copyWith(color: context.color.error),
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: () {
          _handleRetry(context);
        },
        label: const Text('Retry'),
        icon: const Icon(Icons.refresh),
      )
    ]);
  }

  _buildInProgressRegisterWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var loginWidget = (switch (authState) {
      AuthAuthenticateUnauthenticated() => _buildInitialLoginWidget(),
      AuthLoginInitial() => _buildInitialLoginWidget(),
      AuthLoginInProgress() => _buildInProgressRegisterWidget(),
      AuthLoginFailure(message: final msg) => _buildFailureLoginWidget(msg),
      AuthLoginSuccess() => Container(),
      _ => Container(),
    });

    loginWidget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthLoginSuccess():
            context.read<AuthBloc>().add(AuthAuthenticatedStarted());
            break;
          case AuthAuthenticatedSuccess():
            context.go(RouteName.home);
            break;
          default:
        }
      },
      child: loginWidget,
    );
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollViewWithColumn(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: context.text.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 48,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: loginWidget,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
