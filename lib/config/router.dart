import 'package:doantotnghiep/features/auth/bloc/auth_bloc.dart';
import 'package:doantotnghiep/screens/home/home_screen.dart';
import 'package:doantotnghiep/screens/post_create/post_create_screen.dart';
import 'package:doantotnghiep/screens/post_detail/post_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/post/bloc/post_create_bloc.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String postCreate = '/post-create';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticatedSuccess) {
      return null;
    }
    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteName.postDetail,
      builder: (context, state) => PostDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: RouteName.postCreate,
      builder: (context, state) => BlocProvider.value(
        value: state.extra as PostCreateBloc,
        child: const PostCreateScreen(),
      ),
    ),
  ],
);
