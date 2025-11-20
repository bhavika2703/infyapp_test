import 'package:flutter_bloc/flutter_bloc.dart';
import 'video_event.dart';
import 'video_state.dart';
import '../../domain/repositories/video_repository.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository repository;

  VideoBloc({required this.repository}) : super(VideoInitial()) {
    on<LoadVideos>(_onLoad);
    on<SearchVideos>(_onSearch);
  }

  Future<void> _onLoad(LoadVideos event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    try {
      final videos = await repository.fetchVideos(limit: event.limit);
      emit(VideoLoaded(videos));
    } catch (err) {
      emit(VideoError(err.toString()));
    }
  }

  Future<void> _onSearch(SearchVideos event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    try {
      final videos = await repository.searchVideos(event.query, limit: 20);
      emit(VideoLoaded(videos));
    } catch (err) {
      emit(VideoError(err.toString()));
    }
  }
}
