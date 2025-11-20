
import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVideos extends VideoEvent {
  final int limit;
   LoadVideos({this.limit = 20});
  @override
  List<Object?> get props => [limit];
}

class SearchVideos extends VideoEvent {
  final String query;
   SearchVideos(this.query);
  @override
  List<Object?> get props => [query];
}
