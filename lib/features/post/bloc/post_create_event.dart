class PostCreateEvent {}

class PostCreateStarted extends PostCreateEvent {
  final String title, content;

  PostCreateStarted({required this.title, required this.content});
}

class PostCreateRetryStarted extends PostCreateEvent {
  final String title, content;

  PostCreateRetryStarted({required this.title, required this.content});
}
