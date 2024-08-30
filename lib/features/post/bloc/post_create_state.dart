sealed class PostCreateState {}

class PostCreateInitial extends PostCreateState {}

class PostCreateInProgress extends PostCreateState {
  final String title, content;

  PostCreateInProgress({required this.title, required this.content});
}

class PostCreateSuccess extends PostCreateState {}

class PostCreateFailure extends PostCreateState {
  final String title, content, error;

  PostCreateFailure({
    required this.title,
    required this.content,
    required this.error,
  });
}
