import 'package:doantotnghiep/config/router.dart';
import 'package:doantotnghiep/features/auth/bloc/auth_bloc.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_bloc.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_event.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_state.dart';
import 'package:doantotnghiep/utils/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PostCreateBloc> _postCreateBlocs = [];

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  void _handleNewPostButton(BuildContext context) {
    final bloc = PostCreateBloc();
    setState(() {
      _postCreateBlocs.add(bloc);
    });
    bloc.stream.listen((state) {
      if (state is PostCreateSuccess) {
        setState(() {
          _postCreateBlocs.remove(bloc);
        });

        bloc.close();
      }
    });
    context.push(RouteName.postCreate, extra: bloc);
  }

  void _handlePendingPostRetry(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateFailure;
    bloc.add(
        PostCreateRetryStarted(title: state.title, content: state.content));
  }

  Widget _buildPendingPost(PostCreateInProgress state) {
    final titleRow = Text(
      state.title,
      style: context.text.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
    );
    final contentRow = Text(
      state.content,
      style: context.text.bodyMedium,
    );

    final pendingPost = Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleRow,
            const SizedBox(height: 8),
            contentRow,
          ],
        ),
        Positioned.fill(
          child: Container(
              color: Colors.white70,
              child: const Center(child: CircularProgressIndicator())),
        ),
      ]),
    );
    return pendingPost;
  }

  Widget _buildFailurePost(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateFailure;
    final titleRow = Text(
      state.title,
      style: context.text.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
    );
    final contentRow = Text(
      state.content,
      style: context.text.bodyMedium,
    );

    final failurePost = Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleRow,
            const SizedBox(height: 8),
            contentRow,
          ],
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white70,
            child: Center(
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: context.color.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      state.error,
                      style: context.text.headlineMedium!.copyWith(
                        color: context.color.error,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: () {
                        _handlePendingPostRetry(bloc);
                      },
                      icon: const Icon(Icons.refresh),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
    return failurePost;
  }

  @override
  Widget build(BuildContext context) {
    final pendingPosts = _postCreateBlocs.map((bloc) {
      return BlocProvider.value(
        value: bloc,
        child: BlocBuilder<PostCreateBloc, PostCreateState>(
          builder: (context, state) {
            if (state is PostCreateInProgress) {
              return _buildPendingPost(state);
            }
            if (state is PostCreateFailure) {
              return _buildFailurePost(bloc);
            }
            return const SizedBox();
          },
        ),
      );
    });

    final newPostButton = Padding(
      padding: const EdgeInsets.all(24),
      child: FilledButton(
          style: FilledButton.styleFrom(
            elevation: 0,
            backgroundColor: context.color.surface,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
          ),
          onPressed: () {
            _handleNewPostButton(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: context.color.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                'What do you want to ask...?',
                style: context.text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.color.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          )),
    );

    Widget widget = Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            newPostButton,
            ...pendingPosts,
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
