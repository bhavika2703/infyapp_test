
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/model/video_model.dart';

class VideoFirestoreDatasource {
  final FirebaseFirestore _firestore;
  VideoFirestoreDatasource({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<VideoModel>> fetchVideos({required int limit}) async {
    final snap = await _firestore.collection('videos').get();
    return snap.docs.map((d) => VideoModel.fromDoc(d)).toList();
  }



  /// Simple tag-based search (recommended for MVP). For robust text search use Algolia.
  Future<List<VideoModel>> searchVideosByTag(String tag, {int limit = 20}) async {
    final snap = await _firestore.collection('videos').where('tags', arrayContains: tag.toLowerCase()).limit(limit).get();
    return snap.docs.map((d) => VideoModel.fromDoc(d)).toList();
  }

  /// Optional: naive title contains search (works poorly for Firestore). Use only for tiny datasets.
  Future<List<VideoModel>> searchVideosByTitleContains(String q, {int limit = 20}) async {
    final snap = await _firestore.collection('videos').orderBy('createdAt', descending: true).limit(500).get();
    final filtered = snap.docs.where((d) {
      final data = d.data();
      final title = (data['title'] ?? '').toString().toLowerCase();
      return title.contains(q.toLowerCase());
    }).take(limit).map((d) => VideoModel.fromDoc(d)).toList();
    return filtered;
  }
}
