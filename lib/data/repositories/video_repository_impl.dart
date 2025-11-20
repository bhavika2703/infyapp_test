
import '../../domain/model/video_model.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_firestore_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoFirestoreDatasource datasource;
  VideoRepositoryImpl({required this.datasource});

  @override
  Future<List<VideoModel>> fetchVideos({int limit = 20}) => datasource.fetchVideos(limit: limit);

  @override
  Future<List<VideoModel>> searchVideos(String query, {int limit = 20}) {
    return datasource.searchVideosByTag(query, limit: limit);
  }
}
