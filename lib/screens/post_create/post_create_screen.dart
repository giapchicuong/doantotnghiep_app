import 'package:doantotnghiep/features/post/bloc/post_create_bloc.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_event.dart';
import 'package:doantotnghiep/utils/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    context.read<PostCreateBloc>().add(
          PostCreateStarted(
            title: _titleController.text,
            content: _contentController.text,
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleField = TextField(
      controller: _titleController,
      decoration: InputDecoration(
          fillColor: context.color.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          hintText: 'Enter some title'),
      style: context.text.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
    final contextField = TextField(
      controller: _contentController,
      maxLines: 1000,
      decoration: InputDecoration(
          fillColor: context.color.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          hintText: 'Enter some content'),
      style: context.text.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );

    final submitButton = Padding(
      padding: const EdgeInsets.all(24),
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle:
              context.text.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _handleSubmit(context);
        },
        child: const Text('Submit'),
      ),
    );

    final child = Scaffold(
      appBar: AppBar(
        title: const Text('Create new post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            titleField,
            const SizedBox(height: 16),
            Expanded(
              child: contextField,
            ),
            const SizedBox(height: 16),
            submitButton
          ],
        ),
      ),
    );
    return child;
  }
}
