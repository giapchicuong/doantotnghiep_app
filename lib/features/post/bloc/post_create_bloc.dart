import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_event.dart';
import 'package:doantotnghiep/features/post/bloc/post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  PostCreateBloc() : super(PostCreateInitial()) {
    on<PostCreateStarted>(_onPostCreateStarted);
    on<PostCreateRetryStarted>(_onPostCreateRetryStarted);
  }

  void _onPostCreateStarted(
      PostCreateStarted event, Emitter<PostCreateState> emit) async {
    emit(PostCreateInProgress(
      title: event.title,
      content: event.content,
    ));

    await Future.delayed(const Duration(seconds: 2));
    // emit(PostCreateSuccess());

    emit(PostCreateFailure(
      title: event.title,
      content: event.content,
      error: 'Network error',
    ));
  }

  void _onPostCreateRetryStarted(
      PostCreateRetryStarted event, Emitter<PostCreateState> emit) async {
    emit(PostCreateInProgress(
      title: event.title,
      content: event.content,
    ));

    await Future.delayed(const Duration(seconds: 2));

    emit(PostCreateSuccess());
  }
}
