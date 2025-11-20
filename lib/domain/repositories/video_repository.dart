

import '../model/video_model.dart';

abstract class VideoRepository {
  Future<List<VideoModel>> fetchVideos({int limit = 20});
  Future<List<VideoModel>> searchVideos(String query, {int limit = 20});
}
